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
  
  	# Items
  	@items = @folder.items
  
  	# Si le dossier contient des sous-dossiers
    if @folder.children.present?
      # S'il y a beaucoup de tags enfants, il faut afficher la barre alphabet et filtrer par lettre
      @navigate_option = (@folder.children.count > 40)? true : false 
      case params[:letter]
        when "A".."W"
          @subfolders = @folder.children.where(letter: params[:letter])
        when "XYZ"
          @subfolders = @tafolderg.children.where(letter: "X".."Z")
        when "#"
          @subfolders = @folder.children.where(letter: 0..9999999) 
        when "vide"
          @subfolders = @folder.children.where(letter: [nil, ""])
        else
          @subfolders = @folder.children.order(:name)
      end
      # Nombre de tag par colonne
      @folders_per_column = (@subfolders.count.to_f/4).ceil 
    end # @folder.children.present?
  
    # Choix de la vue pour l'affichage des items
    if params[:view].present?
      @view = params[:view]
    else
      #if @folder.default_view.blank?
        @view = "list"
      #else
      #  @view = @folder.default_view
      #end 
    end
    
    # Choix de l'ordre dans lequel afficher les items
    if params[:order].present?
      @order = params[:order]
    else
      @order = @folder.is_root? ? "date" : "number"
    end
  
  
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

    respond_to do |format|
      if @folder.save
        format.html { redirect_to @folder, notice: 'Folder was successfully created.' }
        format.json { render :show, status: :created, location: @folder }
      else
        format.html { render :new }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /folders/1
  # PATCH/PUT /folders/1.json
  def update
    respond_to do |format|
      if @folder.update(folder_params)
        format.html { redirect_to @folder, notice: 'Folder was successfully updated.' }
        format.json { render :show, status: :ok, location: @folder }
      else
        format.html { render :edit }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.json
  def destroy
    @folder.destroy
    respond_to do |format|
      format.html { redirect_to welcome_collector_path, notice: 'Dossier supprimé' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @folder = Folder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def folder_params
      params.require(:folder).permit(:name, :parent_id)
    end
end
