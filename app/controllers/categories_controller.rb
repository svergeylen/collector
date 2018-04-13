class CategoriesController < ApplicationController
	before_action :set_category, only: [:show, :edit, :update, :destroy]

	def index
		@categories = Category.all.order(:name)
	end

	def show
		@category = Category.find(params[:id])
		set_session_category(@category)
		

		# Si l'utilisateur a sélectionné une lettre de l'alphabet, on renvoie uniquement les séries commencant par cette lettre
		letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
		if params[:letter].present?
			# Défense contre l'injection de n'importe quelle valeur par l'utilisateur
			if letters.include?(params[:letter])
				@series = @category.series.where(letter: params[:letter]).order(:name)
			else
				@series = @category.series.where.not(letter: letters).order(:name)
			end
		else
			
			if (@category.series.count < 40) 
				# Si le nombre de séries est limité, on affiche tout
				@series = @category.series.order(:name)
			else
				# Sinon, on affiche les séries favorites
				@series = current_user.series.order(name: :asc)
			end
		end

		# Derniers ajouts
		@latest_items =  @category.items.order(updated_at: :desc).limit(10)
		end

	def new
		@category = Category.new
	end

	def create
		@category = Category.new(category_params)

		if @category.save
			set_session_category(@category)
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
    params.require(:category).permit(:name, :folder_name, :color, :default_view, :view_alphabet, :view_search)
  end

end
