class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    # Appliquer le filtre si la variable "a" est définie
    if params[:a].present?
      a = params[:a].split(",")
      id = a.last
      @tag = Tag.find(id)
      @title  = @tag.name
      @tags = @tag.tags.order(name: :asc)
      @items = @tag.sorted_items
    else
      # Sinon, renvoyer les tag racines 
      @title  = "Collector"
      @tags = Tag.where(root_tag: true).order(name: :asc)
    end

    # Formulaire d'ajout d'item en bas de page
    @new_item = Item.new
  end

  def show
    logger.debug "Tag#show is not implement"
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to @tag, notice: 'Tag créé' 
    else
      render :new 
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
   
    if @tag.update(tag_params)
      redirect_to @tag, notice: 'Tag modifié'
    else
      render :edit
    end
  end

  def destroy
    @tag.destroy 
    redirect_to tags_path, notice: "Tag supprimé"
  end


  private
  
  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

end
