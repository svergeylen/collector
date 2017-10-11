class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :like, :upvote]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
		@item.authors_list = params[:item][:authors_list]
    # L'utilisateur courant a ajouté l'élément
    @item.adder_id = current_user.id
    # Si l'utilisateur courant crée cet élément, on suppose qu'il en possède un seul et qu'il ne l'a pas encore vu/lu/utilisé
    @item.itemusers.build(user_id: current_user.id, quantity: 1)

    if @item.save
			@item.series.touch
			redirect_to @item.series, notice: 'Elément créé'
    else
			render :new 
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
		@item.authors_list = params[:item][:authors_list]
		@item.series.touch

    if @item.update(item_params)
      redirect_to @item.series, notice: 'Elément mis à jour' 
    else
      render :edit 
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
		@item.series.touch
    @item.destroy
    redirect_to items_url, notice: 'Elément supprimé'
  end

  # Gestion des votes sur les items
  def upvote
    if current_user.voted_for? @item
      current_user.unvote_for @item
    else
      current_user.up_votes @item
    end
  end

	# Gestion des likes sur les items
	def like
		logger.debug params.inspect

		@like = @item.add_or_update_like(current_user.id, params[:note], params[:remark])
		puts @like.inspect
		redirect_to @item, notice: 'Elément liké' 
	end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:numero, :name, :series_id)
    end
end
