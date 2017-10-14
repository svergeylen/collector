class AuthorsController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def show
    @author = Author.find(params[:id])
    @series = Series.find( @author.items.collect(&:series_id).uniq! ).sort_by{ |s| s.name }

    colleague_ids = Itemauthor.where(item_id: @author.items.collect(&:id)).where.not(author_id: @author.id).collect(&:author_id).uniq!
    if colleague_ids
      @colleagues = Author.find(colleague_ids).sort_by{ |a| a.name}
    end
  end

  def create
  end

  def edit
    @author = Author.find(params[:id])
  end

  def update
    @author = Author.find(params[:id])
   
    if @author.update(category_params)
      redirect_to @author, notice: 'Auteur modifié'
    else
      render 'edit'
    end
  end

  def destroy
  end


  private
  # Use callbacks to share common setup or constraints between actions.
    def set_category
      @author = Author.find(params[:id])
    end

  def category_params
    params.require(:author).permit(:name)
  end

end
