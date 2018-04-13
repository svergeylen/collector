class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :destroy]

  # Uniquement les root folders
  def index
    @title  = "Collector"
    set_session_breadcrumbs([])
    @children = Folder.where(root_folder: true).order(name: :asc)
  end

  # Affichage d'un seul folder, de ses folders enfants, et des items qu'il contient
  def show
    @folder = Folder.find(params[:id])
    @children = @folder.children
    @items = @folder.sorted_items

    # Choix de la vue 
    if params[:view].present?
      @view = params[:view]
    else
      if @folder.default_view.blank?
        @view = "list"
      else
        @view = @folder.default_view if @folder.default_view != "none"
      end
    end


    # Formulaire d'ajout d'item en bas de page
    @new_item = Item.new

    # Breadcrumbs : Si un chemin de folders est donné en parametre, l'utiliser et le mémoriser
    # Permet de forcer la navigation vers un Folder avec un chemin particulier
    if params[:bc].present?
      bc = params[:bc].split(",")
      set_session_breadcrumbs(bc)
    else
      if session[:bc].empty?
        set_session_breadcrumbs([ @folder.id ])
      end
    end    
  end

  def new
    @folder = Folder.new
    
    # Cherche des folders à proposer pour populer le champ parent_folders
    # proposal = Folder.where(id: get_session_breadcrumbs).where(optional: false).map(&:id)
    # On propose uniquement le premier parent pour éviter la confusion...
    # sinon, on se retrouve avec l'item à tous les niveaux de la hiérarchie (c'est nul)
    @folder.parent_folder_ids = [ params[:parent_folder] ]
  end

  def create
    @folder = Folder.new(folder_params)
    
    if @folder.save
      @folder.update_parent_folders(params[:folder][:parent_folders])
      # Redirection vers le parent du folder créé (comme pour la création de dossier sur pc)
      redirect_to folder_path(get_session_breadcrumbs.last), notice: 'Dossier créé' 
    else
      render :new 
    end
  end

  def edit
    @folder = Folder.find(params[:id])
  end

  def update
    @folder = Folder.find(params[:id])
    @folder.update_parent_folders(params[:folder][:parent_folders])
    
    if @folder.update(folder_params)
      redirect_to @folder, notice: 'Dossier modifié'
    else
      render :edit
    end
  end

  def destroy
    # On mémorise le chemin de retour vers le premier folder parent 
    path = @folder.parent_folders.present? ? folder_path(@folder.parent_folders.first) : folders_path

    # On supprime de la session l'id de ce folder pour éviter un breadcrumb insensé
    set_session_folders(  (session[:a].split(",") - [ @folder.id.to_s ]).join(",")  )

    if @folder.destroy
      redirect_to path, notice: "Dossier supprimé"
    else
      redirect_to path, alert: "Ce dossier ne peut pas être supprimé (fixture)"
    end
  end


  private
  
  def set_folder
    @folder = Folder.find(params[:id])
  end

  def folder_params
    params.require(:folder).permit(:name, :root_folder, :fixture, :optional, :letter, :default_view)
  end

end
