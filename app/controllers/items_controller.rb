class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :upvote, :plus, :minus]

  # Liste des items pour gestion banque de données
  def index
    per_page = 40
    case params[:mode]
      when "Orphelins"
        item_ids_having_tags = Ownertag.all.group(:owner_id).where(owner_type: 'Item').pluck(:owner_id)
        @items = Item.where.not(id: item_ids_having_tags).order(:name).paginate(page: params[:page], per_page: per_page)
      else
        @items = Item.includes(:tags).order(name: :asc).paginate(page: params[:page], per_page: per_page)
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
    
    case params[:view]
    when "bd"
      new_or_edit_bd
      @item.tag_series = params[:series] if params[:series]
      render "items/new_bd"
    else
      @tag_list = Tag.order(name: :asc).pluck(:name)
      @item.tag_names = Tag.where(id: session[:active_tags]).pluck(:name).join(", ")
      render "items/new"
    end
  end


  # GET /items/1/edit
  def edit

    case params[:view]
      when "bd"
        new_or_edit_bd
        render "items/edit_bd"
      else
        @tag_list = Tag.order(name: :asc).pluck(:name)
        render "items/edit"
    end
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @item.adder_id = current_user.id
    
    if @item.save
      # Si l'utilisateur courant crée cet élément, on suppose qu'il en possède un seul et qu'il ne l'a pas encore vu/lu/utilisé
      current_user.add_to_collection(@item.id)
      # Ajout du tag BD si on a utilisé le formulaire "BD"
      add_bd_tag if params[:view] == "bd"
      # Enregistre les pièces jointes (photos)
      save_attachments
      # Crée un job pour l'affichage ultérieur sur La Une
      Job.create(action: "add_item", element_id: @item.id, element_type: "Item", user_id: current_user.id)      

			redirect_to @item, notice: 'Elément ajouté'
    else
			render :new 
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    # params[:item].delete(:view)
    @item.adder_id = current_user.id if @item.adder_id.blank?

    add_bd_tag if params[:view] == "bd"

    if @item.update(item_params)
      save_attachments

      redirect_to @item, notice: 'Elément mis à jour'
    else
      render :edit 
    end
  end


  # Gestion des quantités (Composant React ItemQuantity)
  def quantity
    @item = Item.find(params[:id])
    @iu = @item.update_quantity(params[:delta], current_user.id)
    render partial: "items/quantity.json.jbuilder", locals: {item: @item}
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    redirect_to last_tag_path, notice: 'Elément supprimé'
  end

  # Gestion des actions réalisées sur une liste d'items.
  # params contient la liste des item_id qu'il faut modifier
  def actions 
    if params[:item_ids].nil?
      redirect_to tag_path(params[:tag_id], view: params[:view]), alert: 'Veuillez sélectionner des éléments'
    else

      # On ajoute les items sélectionnés dans la collection de l'utilisateur courant
      if params[:add_to_collection].present?
        params[:item_ids].each do |item_id|
          current_user.add_to_collection(item_id, 1)
        end
        redirect_to tag_path(params[:tag_id], view: params[:view]), notice: 'Eléments ajoutés à ma collection'
      end

      # On enlève les items sélectionnés des possessions de l'utilisateur courant
      if params[:remove_from_collection].present?
        params[:item_ids].each do |item_id|
          current_user.add_to_collection(item_id, -1)
        end
        redirect_to tag_path(params[:tag_id], view: params[:view]), notice: 'Eléments enlevés de ma collection'
      end

      # On enlève les items sélectionnés des possessions de l'utilisateur courant
      if params[:destroy].present?
        Item.where(id: params[:item_ids]).destroy_all
        redirect_to tag_path(params[:tag_id], view: params[:view]), notice: 'Eléments supprimés du Collector'
      end

      # On écrase le rangement des items donnés vers le(s) nouveaux rangement(s) donné(s)
      if params[:move].present?
        result = true
        params[:item_ids].each do |item_id|
          i = Item.find(item_id)
          result = i.update_tags_with_parent(params[:rangements].split(","), "Rangements") && result
        end
        if result
          redirect_to tag_path(params[:tag_id], view: params[:view]), notice: 'Rangement modifié pour les items sélectionnés'
        else
          redirect_to tag_path(params[:tag_id], view: params[:view]), alert: 'Erreur lors de la modification du rangement'
        end
      end

      # On ajoute le(s) tag(s) donné(s) aux items sélectionnés
      if params[:add_tag].present?
        params[:item_ids].each do |item_id|
          i = Item.find(item_id)
          result = i.add_tags(params[:tag_names].split(","))
        end
        redirect_to tag_path(params[:tag_id], view: params[:view]), notice: 'Tag(s) ajouté(s) aux items sélectionnés'
      end

      # On supprimer un même tag des items sélectionnés
      if params[:remove_tag].present?
        params[:item_ids].each do |item_id|
          i = Item.find(item_id)
          result = i.remove_tags(params[:tag_names].split(","))
        end
        redirect_to tag_path(params[:tag_id], view: params[:view]), notice: 'Tag(s) retirés(s) des items sélectionnés'
      end

    end # if item_ids.empty?
  end

  # Supprimer un attachment de l'item
  def delete_attachment
    @item = Item.find(params[:id])
    if @item.attachments.exists?(params[:attachment_id])
      @item.attachments.find(params[:attachment_id]).destroy
      redirect_to edit_item_path(@item), notice: 'Pièce jointe supprimée' 
    else
      redirect_to edit_item_path(@item), alert: 'Erreur lors de la suppression de la pièce jointe' 
    end
  end


  private
    # Sauvegarde les attachments s'il y en a
    def save_attachments
      # Paperclip multiple upload of attachments on Item
      if params[:item][:attachments]
        params[:item][:attachments].each { |attach|
          @item.attachments.create(image: attach, user_id: current_user.id)
        }
      end
    end

    # Méthodes utilisées par les 2 formulaires spécifiques aux BD : new + edit
    def new_or_edit_bd
      tag_series = Tag.find_or_create_by(name: "Séries")
      @series_list = tag_series.children.pluck(:name)

      tag_auteurs = Tag.find_or_create_by(name: "Auteurs")
      @auteurs_list = tag_auteurs.children.pluck(:name)

      tag_rangement = Tag.find_or_create_by(name: "Rangements")
      @rangements_list = tag_rangement.children.pluck(:name)
    end

    # Ajout du tag BD à l'item (à appeler si le formulaire BD a été utilisé)
    def add_bd_tag
      bd = Tag.find_or_create_by!(name: "Bandes dessinées")
      @item.tags << bd unless @item.tags.include?(bd)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:number, :name, :description, :attachments, :tag_names, :tag_series, :tag_auteurs, :tag_rangements)
    end
end
