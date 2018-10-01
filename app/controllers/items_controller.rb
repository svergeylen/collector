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
    # Si l'utilisateur courant crée cet élément, on suppose qu'il en possède un seul et qu'il ne l'a pas encore vu/lu/utilisé
    @item.itemusers.build(user_id: current_user.id, quantity: 1)

    # Si l'item est une BD (form BD), alors on lui ajoute ce tag "BD" d'office
    # if params[:view] == "bd"
    #   logger.debug "---------> Ajout Tag Bandes dessinées d'office"
    #   @item.tags << Tag.first_or_create!(name: "Bandes dessinées")
    # end
    params.delete(:view)

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
    # params[:item].delete(:view)
    @item.adder_id = current_user.id if @item.adder_id.blank?

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
    redirect_to welcome_collector_path, notice: 'Elément supprimé'
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
      @series_list = Tag.with_parent("Séries").pluck(:name)
      @auteurs_list = Tag.with_parent("Auteurs").pluck(:name)
      @rangements_list = Tag.with_parent("Rangements").pluck(:name)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:number, :name, :description, :attachments, :view, :tag_names, :tag_series, :tag_auteurs, :tag_rangements)
    end
end
