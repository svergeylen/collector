class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

def index
	@categories = Category.all.order(:name)
	@latest_items = Item.order(created_at: :desc).limit(20)
	# set_session_category(nil)
	end

def show
	set_session_category(params[:id])
	@category = Category.find(params[:id])
	@series = @category.series.order(updated_at: :desc).limit(7)
	@latest_items =  @category.items.order(created_at: :desc).limit(7)
	end

def new
	@category = Category.new
end

def create
	@category = Category.new(category_params)

	if @category.save
		set_session_category(@category.id)
	  redirect_to @category, notice: "Nouvelle catégorie créée"
	else
	  render 'new'
	end
	
end

def edit
	@category = Category.find(params[:id])
end

def update
	@category = Category.find(params[:id])
 
	if @category.update(category_params)
	  redirect_to @category, notice: 'Catégorie modifiée'
	else
	  render 'edit'
	end
end

def destroy
	@category = Category.find(params[:id])
	@category.destroy
 
	redirect_to categories_path, notice: 'Catégorie supprimée'
end

private
 	# Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

  def category_params
    params.require(:category).permit(:name, :default_view, :color)
  end

end
