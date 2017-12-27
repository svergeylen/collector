class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
    @items = @tag.items
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
