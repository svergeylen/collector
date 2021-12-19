class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :enhance]

  # Liste des items pour gestion banque de données
  def index
    per_page = 40
    case params[:mode]
      when "Orphelins"
        @items = Item.where(folder: [nil, ""]).paginate(page: params[:page], per_page: per_page)
      else
        @items = Item.order(id: :asc).paginate(page: params[:page], per_page: per_page)
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
		# breadcrumbs 
		@ancestors = Folder.find(@item.folder.path_ids)

    # Notes associées à cet item
    @notes = @item.notes.includes(:user).order(created_at: :asc)
    
    # Ajout d'information pour la création d'un item
    next_number = (@item.number + 1) if @item.number.present?
    proposed_tag_ids = @item.tags.pluck(:id)
    @new_item_options = {number: next_number, tag_ids: proposed_tag_ids}
  end

  # GET /items/new
  def new
    @item = Item.new
    # Pré-remplissage du formulaire au mieux
    @item.number = params[:number] if (params[:number].present?)
    @item.name = params[:name] if (params[:name].present?)
    @item.description = params[:description] if (params[:description].present?)
    @item.tag_names = params[:tag_names] if params[:tag_names].present?
    @item.folder_id = params[:folder_id] if params[:folder_id].present?
    render_correct_form("new")
  end


  # GET /items/1/edit
  def edit   
    render_correct_form("edit")
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @item.adder_id = current_user.id

    if @item.save
      # Si l'utilisateur coche l'option "ajouter à ma collection", on ajoute cet élément directement.
      if params[:add_to_collection].present?
        current_user.add_to_collection(@item.id)
      end
      # Enregistre les pièces jointes (photos)
      save_attachments
      # Crée un job pour l'affichage ultérieur sur La Une
      Job.create(action: "add_item", element_id: @item.id, element_type: "Item", user_id: current_user.id)      

			redirect_to @item.folder, notice: 'Elément ajouté'
    else
      render_correct_form("edit")
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    @item.adder_id = current_user.id if @item.adder_id.blank? # défensif

    if @item.update(item_params)
      save_attachments
      redirect_to @item, notice: 'Elément mis à jour'
    else
      render_correct_form("edit")
    end
  end


  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    redirect_to welcome_collector_path, notice: 'Elément supprimé'
  end


  # Gestion des actions réalisées sur une liste d'items.
  # params contient la liste des item_id qu'il faut modifier
  def actions 
  	# Chemin de redirection
		back = folder_path(params[:folder_id], view: params[:view])

    if params[:item_ids].nil?
      redirect_to back, alert: 'Veuillez sélectionner des éléments'
    else

      # On ajoute les items sélectionnés dans la collection de l'utilisateur courant
      if params[:add_to_collection].present?
        params[:item_ids].each do |item_id|
          current_user.add_to_collection(item_id, 1)
        end
        redirect_to back, notice: 'Eléments ajoutés à ma collection'
      end

      # On enlève les items sélectionnés des possessions de l'utilisateur courant
      if params[:remove_from_collection].present?
        params[:item_ids].each do |item_id|
          current_user.add_to_collection(item_id, -1)
        end
        redirect_to back, notice: 'Eléments enlevés de ma collection'
      end

      # On enlève les items sélectionnés des possessions de l'utilisateur courant
      if params[:destroy].present?
        Item.where(id: params[:item_ids]).destroy_all
        redirect_to back, notice: 'Eléments supprimés du Collector'
      end


			# Déplacement dans un autre sous dossier
      if params[:move_to_folder].present?
      	if params[:folder_names].present?
		      params[:item_ids].each do |item_id|
		        i = Item.find(item_id)
		        i.folder_name = params[:folder_names].split(",").first
		        i.save_folder
		        i.save
		      end
	        redirect_to back, notice: 'Item déplacé dans le dossier'
	      else
	        redirect_to back, notice: 'Pas de dossier sélectionné ou trouvé'
	      end
	       
      end
      
      # On ajoute le(s) tag(s) donné(s) aux items sélectionnés
      if params[:add_tag].present?
        params[:item_ids].each do |item_id|
          i = Item.find(item_id)
          result = i.add_tags(params[:tag_names].split(","))
        end
        redirect_to back, notice: 'Tag(s) ajouté(s) aux items sélectionnés'
      end

      # On supprimer un même tag des items sélectionnés
      if params[:remove_tag].present?
        params[:item_ids].each do |item_id|
          i = Item.find(item_id)
          result = i.remove_tags(params[:tag_names].split(","))
        end
        redirect_to back, notice: 'Tag(s) retirés(s) des items sélectionnés'
      end

    end # if item_ids.empty?
  end

  # Supprimer un attachment de l'item
  def delete_attachment
    @item = Item.find(params[:id])
    if @item.attachments.exists?(params[:attachment_id])
      @item.attachments.find(params[:attachment_id]).destroy
      @item.touch
      redirect_to edit_item_path(@item), notice: 'Pièce jointe supprimée' 
    else
      redirect_to edit_item_path(@item), alert: 'Erreur lors de la suppression de la pièce jointe' 
    end
  end

  # Extraction d'information depuis un site tiers
  def enhance
    @item.enhance

    respond_to do |format|
      format.js
    end
  end


  private   
    # Sauvegarde les attachments s'il y en a
    def save_attachments
      # Paperclip multiple upload of attachments on Item
      if params[:item][:attachments]
      	list_of_attachments = []
        params[:item][:attachments].each { |attach|
          tmp = @item.attachments.create(image: attach, user_id: current_user.id)
          @item.touch
          list_of_attachments << tmp.id
        }
        
        # Crée un job pour afficher les nouvelles images sur la Une
	      Job.create!(action: "add_pictures", element_id: @item.id, element_type: "Item", 
  	      user_id:current_user.id, memory: { attachment_ids: list_of_attachments })

      end
    end

    # Realise toutes les opérations communes pour les formulaires new/edit (y compris avec erreur de validation)
    def render_correct_form(action)
      @folders_list = Folder.select(:name).order(:name).pluck(:name).to_json
    	@tag_list = Tag.order(name: :asc).pluck(:name)
    	if @item.folder.present? and @item.folder.parent.present?
	    	@parent_name = @item.folder.parent.name
    	end
      render "items/"+action
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      if Item.exists?(params[:id])
        @item = Item.find(params[:id])
      else
        back = request.env["HTTP_REFERER"] || welcome_collector_path
        redirect_to back, alert: "Item introuvable. Il a probablement été supprimé."
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:number, :name, :folder_id, :folder_name, :parent_name, :description, :attachments, :tag_names)
    end
end
