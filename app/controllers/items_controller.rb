class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :like, :upvote]

  # GET /items/1
  # GET /items/1.json
  def show
    h = @item.next_and_previous_ids
    @next_id = h[:next]
    @previous_id = h[:previous]
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
		@item.authors_list = params[:item][:authors_list] if params[:item][:authors_list]
    @item.adder = current_user  if @item.adder.blank?
		@item.series.touch

    if @item.update(item_params)
      # Paperclip multiple upload of attachments on Item
      if params[:item][:attachments]
        params[:item][:attachments].each { |attach|
          @item.attachments.create(image: attach, user_id: current_user.id)
        }
      end

      redirect_to @item, notice: 'Elément mis à jour' 
    else
      render :edit 
    end
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
      redirect_to @item, notice: 'Pièce jointe supprimée' 
    else
      redirect_to @item, alert: 'Erreur lors de la suppression de la pièce jointe' 
    end
  end


  # Gestion des votes sur les items
  def upvote
    if current_user.voted_for? @item
      current_user.unvote_for @item
    else
      current_user.up_votes @item
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:numero, :name, :series_id, :attachments)
    end
end
