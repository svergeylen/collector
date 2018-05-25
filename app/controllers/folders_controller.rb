class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :destroy]

  # Uniquement les root folders
  def index
    @title  = "Collector"
    set_session_breadcrumbs([])
    @root_folders = Folder.where(root_folder: true).order(name: :asc)

    # Recherche de dossiers potentiellement orphelins (suppression de leur parent ou erreur database)
		all_folders = Folder.where(root_folder: false).map(&:id)
		all_folders_with_parent = Ownerfolder.where(owner_type: "Folder").map(&:folder_id)
		orphan_ids = all_folders - all_folders_with_parent
		@orphans = Folder.find(orphan_ids)

  end

  # Affichage d'un seul folder, de ses subfolders, et des items qu'il contient
  def show
    @folder = Folder.find(params[:id])
    @children = @folder.children
    
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

	# Récupération des items seulement s'il faut les afficher
	@items = @folder.sorted_items if @view.present?

    # Formulaire d'ajout d'item en bas de page
    @new_item = Item.new

    # Breadcrumbs : Si un chemin de folders est donné en parametre, l'utiliser et le mémoriser
    # Permet de forcer la navigation vers un Folder avec un chemin particulier
    if params[:bc].present?
      bc = params[:bc].split(",")
      set_session_breadcrumbs(bc)
    else
      # On n'a pas de breadcrumbs imposées
      bc = get_session_breadcrumbs
      if bc.empty?
        # On initialise les breadcrumbs au folder en cours
        set_session_breadcrumbs([ @folder.id.to_s ])
      else 
        # On complète la liste des breadcrumbs avec le folder courant (sauf si enditique = page refresh )
        bc << @folder.id if !bc.include? @folder.id.to_s
        set_session_breadcrumbs(bc)
      end
    end    
  end

  def new
    @folder = Folder.new
    
    # Cherche des folders à proposer pour populer le champ parent_folders
    # proposal = Folder.where(id: get_session_breadcrumbs).where(optional: false).map(&:id)
    # On propose uniquement le premier parent pour éviter la confusion...
    # sinon, on se retrouve avec l'item à tous les niveaux de la hiérarchie (c'est nul)
    @folder.parent_folder_ids = [ params[:parent_folder].to_s ]
  end

  def create
    @folder = Folder.new(folder_params)
    
    if @folder.save
      @folder.update_parent_folders(params[:folder][:parent_folders])
			if @folder.root_folder?
				redirect_to folders_path, notice: "Dossier créé"
			else
				# Redirection vers le parent du folder créé (comme pour la création de dossier sur pc)
				redirect_to folder_path(get_session_breadcrumbs.last), notice: 'Dossier créé' 
			end
    else
      render :new 
      # ICI BUG : lorsqu'il y a une erreur de validation, on perd la valeur de @folder.parent_folder_ids ???
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
    
    # On supprime le dernier folder de la liste des breadcrumb
    bc = get_session_breadcrumbs
    bc.pop
    set_session_breadcrumbs( bc )

    # On mémorise le chemin de retour vers le premier folder parent (selon les breadcrumbs)
    path = bc.size > 0 ? folder_path(bc.last) : folders_path

    # BUG : Il faut prévoir le déplacement des folders enfants qui deviennent orphelins vers root_folder=true

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
    params.require(:folder).permit(:name, :root_folder, :fixture, :optional, :letter, :default_view, :view_alphabet)
  end

end
