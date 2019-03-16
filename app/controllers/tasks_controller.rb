class TasksController < ApplicationController

  def create
    @item = Item.find(params[:item_id])
    @task = @item.tasks.create(task_params.merge(user_id: current_user.id) ) 
    redirect_to item_path(@item)
  end
 
  private
    def task_params
      params.require(:task).permit(:classification, :message, :user_id, :created_at)
    end
	
end
