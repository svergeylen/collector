class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :upvote, :plus, :minus]

  # GET /items/1
  # GET /items/1.json
  def show
    h = @item.next_and_previous_ids
    @next_id = h[:next]
    @previous_id = h[:previous]
    @attachments = @item.attachments
  end

  # GET /items/new
  def new
    @item = Item.new(series_id: params[:series_id])
    @series = Series.find(@item.series_id) if params[:series_id]
  end

  # GET /items/1/edit
  def edit
    @series = @item.series
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
		@item.tags_list = params[:item][:tags_list]
    # L'utilisateur courant a ajouté l'élément
    @item.adder_id = current_user.id
    # Si l'utilisateur courant crée cet élément, on suppose qu'il en possède un seul et qu'il ne l'a pas encore vu/lu/utilisé
    @item.itemusers.build(user_id: current_user.id, quantity: 1)

    if @item.save
			@item.series.touch
      save_attachments
      Job.create(action: "add_item", element_id: @item.id, element_type: "Item", user_id: current_user.id)
      
			redirect_to @item.series, notice: 'Elément ajouté'
    else
			render :new 
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
		@item.tags_list = params[:item][:tags_list] if params[:item][:tags_list]
    @item.adder = current_user if @item.adder.blank?
		@item.series.touch

    if @item.update(item_params)
      save_attachments

      redirect_to @item, notice: 'Elément mis à jour'
    else
      render :edit 
    end
  end

  # Gestion des votes sur les comments
  def upvote
    if current_user.voted_for? @comment
      current_user.unvote_for @comment
    else
      current_user.up_votes @comment
    end
  end

  # Gestion des quantités (Composant React ItemQuantity)
  def quantity
    @item = Item.find(params[:id])
    @iu = @item.update_quantity(params[:delta], current_user.id)
    render partial: "items/quantity.json.jbuilder", locals: {item: @item}
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
		@item.series.touch
    @item.destroy
    redirect_to @item.series, notice: 'Elément supprimé'
  end


  # Supprimer un attachment de l'item
  def delete_attachment
    @item = Item.find(params[:id])
    if @item.attachments.exists?(params[:attachment_id])
      @item.attachments.find(params[:attachment_id]).destroy
      redirect_to edit_item_path(@item), notice: 'Pièce jointe supprimée' 
    else
      redirect_to edit_item_path(@item), alert: 'Erreur lors de la suppression de la pièce jointe' 
    end
  end


  # Gestion des votes "like" sur les items
  def upvote
    if current_user.voted_for? @item
      current_user.unvote_for @item
    else
      current_user.up_votes @item
    end
  end

  private
    # Sauvegarde les attachments s'il y en a
    def save_attachments
      # Paperclip multiple upload of attachments on Item
      if params[:item][:attachments]
        params[:item][:attachments].each { |attach|
          @item.attachments.create(image: attach, user_id: current_user.id)
        }
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:number, :name, :series_id, :description, :attachments)
    end
end
