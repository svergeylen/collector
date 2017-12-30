class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # Uniquement les root tags
  def index
    @title  = "Collector"
    set_session_tags("")
    @children = Tag.where(root_tag: true).order(name: :asc)
  end

  # Affichage d'un seul tag, de ses tags enfants, et des items qu'il contient
  def show
    @tag = Tag.find(params[:id])
    @children = @tag.tags.order(name: :asc)
    @items = @tag.sorted_items

    # Formulaire d'ajout d'item en bas de page
    @new_item = Item.new

    # Breadcrumbs : Si un chemin de tags est donné en parametre, l'tiliser et le mémoriser
    if params[:a].present?
      a = params[:a].split(",")
      set_session_tags(params[:a])
    else
      # Sinon, utiliser celui qui est en mémoire
      a = session[:a].split(",")
    end    
  end

  def new
    @tag = Tag.new
    # Cherche des tags à proposer pour populer le champ parent_tags
    proposal = Tag.where(id: get_session_tags).where(optional: false).map(&:id)
    @tag.parent_tag_ids = proposal
  end

  def create
    @tag = Tag.new(tag_params)
    
    if @tag.save
      @tag.update_parent_tags(params[:tag][:parent_tags])
      redirect_to @tag, notice: 'Dossier créé' 
    else
      render :new 
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
    # On mémorise le chemin de retour vers le premier tag parent 
    path = @tag.parent_tags.present? ? tag_path(@tag.parent_tags.first) : tags_path

    # On supprime de la session l'id de ce tag pour éviter un breadcrumb insensé
    set_session_tags(  (session[:a].split(",") - [ @tag.id.to_s ]).join(",")  )

    @tag.destroy
    redirect_to path, notice: "Dossier supprimé"
  end


  private
  
  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :root_tag, :fixture, :optional)
  end

end
