class NotesController < ApplicationController

  def create
    @item = Item.find(params[:item_id])
    logger.debug "-------------->"+params.inspect
    @task = @item.notes.create(note_params.merge(user_id: current_user.id) ) 
    redirect_to item_path(@item)
  end
 
  private
    def note_params
      params.require(:note).permit(:classification, :message, :user_id, :created_at)
    end
	
end
