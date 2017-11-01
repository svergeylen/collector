class TagsController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def show
    @tag = Tag.find(params[:id])
    @series = Series.find( @tag.items.collect(&:series_id).uniq ).sort_by{ |s| s.name }
    @related_tags = @tag.related
  end

  def create
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
   
    if @tag.update(category_params)
      redirect_to @tag, notice: 'Tag modifié'
    else
      render 'edit'
    end
  end

  def destroy
    @tag.destroy 
    redirect_to categories_path, notice: "Tag supprimé"
  end


  private
  # Use callbacks to share common setup or constraints between actions.
    def set_category
      @tag = Tag.find(params[:id])
    end

  def category_params
    params.require(:tag).permit(:name)
  end

end
