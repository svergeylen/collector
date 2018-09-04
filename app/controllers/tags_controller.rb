class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # Uniquement les root tags
  def index
    @title  = "Collector"
    set_session_breadcrumbs([])
    @root_tags = Tag.where(root_tag: true).order(name: :asc)

    # Recherche de dossiers potentiellement orphelins (suppression de leur parent ou erreur database)
		all_tags = Tag.where(root_tag: false).map(&:id)
		all_tags_with_parent = Ownertag.where(owner_type: "Tag").map(&:tag_id)
		orphan_ids = all_tags - all_tags_with_parent
		@orphans = Tag.find(orphan_ids)

  end

  # Affichage d'un seul tag, de ses subtags, et des items qu'il contient
  def show
    @tag = Tag.find(params[:id])
    @children = @tag.children
    
    # Choix de la vue 
    if params[:view].present?
      @view = params[:view]
    else
      if @tag.default_view.blank?
        @view = "list"
      else
        @view = @tag.default_view if @tag.default_view != "none"
      end
    end

		# Récupération des items seulement s'il faut les afficher
		@items = @tag.sorted_items if @view.present?

    # Formulaire d'ajout d'item en bas de page
    @new_item = Item.new

    # Breadcrumbs : Si un chemin de tags est donné en parametre, l'utiliser et le mémoriser
    # Permet de forcer la navigation vers un Tag avec un chemin particulier
    if params[:bc].present?
      bc = params[:bc].split(",")
      set_session_breadcrumbs(bc)
    else
      # On n'a pas de breadcrumbs imposées
      bc = get_session_breadcrumbs
      if bc.empty?
        # On initialise les breadcrumbs au tag en cours
        set_session_breadcrumbs([ @tag.id.to_s ])
      else 
        # On complète la liste des breadcrumbs avec le tag courant (sauf si identique = page refresh )
        bc << @tag.id if !bc.include? @tag.id
        set_session_breadcrumbs(bc)
      end
    end    
  end

  def new
    @tag = Tag.new
    
    # Cherche des tags à proposer pour populer le champ parent_tags
    # proposal = Tag.where(id: get_session_breadcrumbs).where(optional: false).map(&:id)
    # On propose uniquement le premier parent pour éviter la confusion...
    # sinon, on se retrouve avec l'item à tous les niveaux de la hiérarchie (c'est nul)
    @tag.parent_tag_ids = [ params[:parent_tag].to_s ]
  end

  def create
    @tag = Tag.new(tag_params)
    
    if @tag.save
      @tag.update_parent_tags(params[:tag][:parent_tags])
			if @tag.root_tag?
				redirect_to tags_path, notice: "Dossier créé"
			else
				# Redirection vers le parent du tag créé (comme pour la création de dossier sur pc)
				redirect_to tag_path(get_session_breadcrumbs.last), notice: 'Dossier créé' 
			end
    else
      render :new 
      # ICI BUG : lorsqu'il y a une erreur de validation, on perd la valeur de @tag.parent_tag_ids ???
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    @tag.update_parent_tags(params[:tag][:parent_tags])
    
    if @tag.update(tag_params)
      redirect_to @tag, notice: 'Dossier modifié'
    else
      render :edit
    end
  end

  def destroy
    
    # On supprime le dernier tag de la liste des breadcrumb
    bc = get_session_breadcrumbs
    bc.pop
    set_session_breadcrumbs( bc )

    # On mémorise le chemin de retour vers le premier tag parent (selon les breadcrumbs)
    path = bc.size > 0 ? tag_path(bc.last) : tags_path

    # BUG : Il faut prévoir le déplacement des tags enfants qui deviennent orphelins vers root_tag=true

    if @tag.destroy
      redirect_to path, notice: "Dossier supprimé"
    elseapp/controllers/application_controller.rb
      redirect_to path, alert: "Ce dossier ne peut pas être supprimé (fixture)"
    end
  end


  private
  
  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :root_tag, :fixture, :optional, :letter, :default_view, :view_alphabet)
  end

end
