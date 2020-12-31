class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :destroy]

  # GET /folders
  def index
    @folders = Folder.all
  end

  # GET /folders/1
  def show
  	# Breadcrumbs
		@ancestors = Folder.find(@folder.path_ids)
   	# Derniers items modifiés dans cette catégorie
		if @folder.is_root?
			@last_modified = @folder.last_modified
		else
			@last_modified = []
		end
		
    # Si le dossier contient des sous-dossiers
    if @folder.children.present?
      # S'il y a beaucoup de tags enfants, il faut afficher la barre alphabet et filtrer par lettre
      @navigate_option = (@folder.children.count > 20)? true : false 
      case params[:letter]
	      when "#"
	      	@subfolders = @folder.children.where(letter: "1".."9").order('lower(name)')
        when "A".."V"
          @subfolders = @folder.children.where(letter: params[:letter]).order('lower(name)')
        when "WXYZ"
          @subfolders = @folder.children.where(letter: "W".."Z").order('lower(name)')
        when "#"
          @subfolders = @folder.children.where(letter: 0..9999999).order('lower(name)')
        else
          @subfolders = @folder.children.order('lower(name)')
      end
      # Nombre de tag par colonne
      @folders_per_column = (@subfolders.count.to_f/4).ceil 
    end # @folder.children.present?
  
  	# Choix de l'ordre dans lequel afficher les items
    if params[:order].present?
      @order = params[:order]
    else
      @order = @folder.is_root? ? "date" : "number"
    end
    
  	# Items directs. N'affiche que les items dans ce dossier ci (sans inclure les sous-dossiers)
  	if (@order == "date") 
	  	@items = @folder.items.order(updated_at: :desc)
  	else 
	  	@items = @folder.items.order(number: :asc)
  	end

    # Choix de la vue pour l'affichage des items
    if params[:view].present?
      @view = params[:view]
    else
      if @folder.default_view.blank?
        @view = "list"
      else
        @view = @folder.default_view
      end 
    end
    
    # Tag list pour actions
    @tag_list = Tag.all.order(name: :asc).pluck(:name)
    # Suggestions pour l'ajout de nouvel item
    if @items.present?
	    last_item = @items.order(:number).last
	    number = last_item.number || 0
  	  @new_item_options = { number: number+1 , tag_names: last_item.tag_names, folder_id: @folder.id}
  	else 
  		@new_item_options = { number: 1, folder_id: @folder.id}
  	end
  	# Suggestion pour l'ajout de nouveau dossier
  	# parent_id = @folder.is_root? ? "" : @folder.parent.id
  	@new_folder_options = { parent_id: @folder.id }
  	  
  end

  # GET /folders/new
  def new
  	new_and_edit_actions
    @folder = Folder.new
    @folder.parent_id = params[:parent_id] 
  end

  # GET /folders/1/edit
  def edit
  	new_and_edit_actions
  end

  # POST /folders
  def create
    @folder = Folder.new(folder_params)
		if @folder.save
		 	redirect_to @folder, notice: 'Dossier créé avec succès'
		else
			render :new 
    end
  end

  # PATCH/PUT /folders/1
  def update
    if @folder.update(folder_params)
			redirect_to @folder, notice: 'Dossier mis à jour'
    else
			render :edit
    end
  end

  # DELETE /folders/1
  def destroy
    @folder.destroy
		redirect_to welcome_collector_path, notice: 'Dossier supprimé'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @folder = Folder.find(params[:id])
    end
    
    def new_and_edit_actions
			@folders_list = Folder.select(:name).order(:name).pluck(:name).to_json
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def folder_params
      params.require(:folder).permit(:name, :parent_name, :letter, :default_view)
    end
end
