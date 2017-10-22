class SeriesController < ApplicationController
  before_action :set_series, only: [:show, :edit, :update, :destroy, :star]

  # GET /series
  # GET /series.json
  def index
    @series = Series.all
  end

  # GET /series/1
  # GET /series/1.json
  def show
		set_session_category(@series.category.id)
    @items = @series.sorted_items

    # Formulaire d'ajout d'item
		@new_item = Item.new
		@new_item.series_id = params[:id]
		if @items.last.present?
      @new_item.numero = @items.last.numero.next
		else
			@new_item.numero = 1
		end
		@new_item.authors_list = @items.last.authors_list if @items.last.present?

    # Vue en liste ou en galerie ?
    if params[:view].present? 
      @gallery_view = (params[:view] == "gallery") ? true : false
    else
      @gallery_view = (@series.category.default_view == "gallery") ? true : false
    end

    # Série favorite ?
    @starred = current_user.series.exists?(@series.id) ? true : false
  end

  # GET /series/new
  def new
    @series = Series.new
		if params[:category_id].present?
      @series.category_id = params[:category_id] 
    else
      @series.category_id = session[:category]
    end
    if params[:name].present?
      @series.name = params[:name].capitalize
      @series.letter = params[:name][0].capitalize
    end
  end

  # GET /series/1/edit
  def edit
  end

  # POST /series
  # POST /series.json
  def create
    @series = Series.new(series_params)
    @series.name = @series.name.capitalize
    @series.letter = params[:series][:name][0].capitalize if @series.letter.blank?

    if @series.save
      redirect_to @series, notice: 'Série créée' 
    else
			render :new 
    end
  end

  # PATCH/PUT /series/1
  # PATCH/PUT /series/1.json
  def update
    if @series.update(series_params)
     	redirect_to @series, notice: 'Série mise à jour'
    else
      render :edit 
    end
  end

  # DELETE /series/1
  # DELETE /series/1.json
  def destroy
    category_id = @series.category_id
    @series.destroy
 		redirect_to category_path(category_id), notice: 'Série supprimée' 
	end

  # Ajoute la serie à la liste des séries favorites de l'utilisateur ou la supprime des favoris si existant
  def star
    if current_user.series.exists?(@series.id)
      current_user.series.delete(@series)
      @glyph = "glyphicon-star-empty"
    else
      current_user.series << @series
      @glyph = "glyphicon-star"
    end
    
    respond_to do |f|
      f.html { redirect_to @series }
      f.js
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_series
      @series = Series.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def series_params
      params.require(:series).permit(:name, :category_id, :letter)
    end
end
