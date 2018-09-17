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
    @attachments = @item.attachments
  end

  # GET /items/new
  def new
    @item = Item.new
    
    # Redirection vers la vue spécifique en fonction du type souhaité
    case params[:view]
    # Vue spécifique pour la création d'un item "BD"
    when "bd"
      # Champ séries
      tag_bd = Tag.where(name: "Bandes dessinées").first
      @series = tag_bd.nil? ? Tag.all : tag_bd.children
      @series_prefilled_ids = [ tag_bd.id ] + session[:active_tags]
      @series_prefilled_ids.uniq!
      # Champ Auteurs
      tag_auteurs = Tag.where(name:"Auteurs").first
      @auteurs = tag_auteurs.nil? ? Tag.all : tag_auteurs.children
      @auteurs_prefilled_ids = []
      # Champ Rangement
      tag_rangement = Tag.where(name: "Rangement").first
      @rangements = tag_rangement.nil? ? Tag.all : tag_rangement.children
      @rangements_prefilled_ids = []
    
      render "items/new_bd"
    else
      # Vue par défaut pour la création de tout type d'item
      render "new"
    end
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
		@item.update_tag_ids(params[:item][:tag_ids])
    @item.adder_id = current_user.id
    # Si l'utilisateur courant crée cet élément, on suppose qu'il en possède un seul et qu'il ne l'a pas encore vu/lu/utilisé
    @item.itemusers.build(user_id: current_user.id, quantity: 1)

    if @item.save
      save_attachments
      Job.create(action: "add_item", element_id: @item.id, element_type: "Item", user_id: current_user.id)
      
			redirect_to @item, notice: 'Elément ajouté'
    else
			render :new 
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
		@item.tags_list = params[:item][:tags_list] if params[:item][:tags_list]

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
    redirect_back fallback_location: welcome_collector_path, notice: 'Elément supprimé'
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

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:number, :name, :description, :attachments, tag_ids: [])
    end
end
