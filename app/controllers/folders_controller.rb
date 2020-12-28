class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :destroy]

  # GET /folders
  # GET /folders.json
  def index
    @folders = Folder.all
  end

  # GET /folders/1
  # GET /folders/1.json
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
    
    # tag list pour actions
    @tag_list = Tag.all.order(name: :asc).pluck(:name)
    # Suggestions pour l'ajout de nouvel item
    last_item = @items.order(:number).last
    @new_item_options = { number: last_item.number+1 , tag_names: last_item.tag_names, folder_id: @folder.id}
    
  end

  # GET /folders/new
  def new
    @folder = Folder.new
  end

  # GET /folders/1/edit
  def edit
  end

  # POST /folders
  # POST /folders.json
  def create
    @folder = Folder.new(folder_params)
		if @folder.save
		 	redirect_to @folder, notice: 'Folder was successfully created.'
		else
			render :new 
    end
  end

  # PATCH/PUT /folders/1
  # PATCH/PUT /folders/1.json
  def update
    if @folder.update(folder_params)
			redirect_to @folder, notice: 'Folder was successfully updated.'
    else
			render :edit
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.json
  def destroy
    @folder.destroy
		redirect_to welcome_collector_path, notice: 'Dossier supprimé'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @folder = Folder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def folder_params
      params.require(:folder).permit(:name, :parent_id, :letter, :default_view)
    end
end
