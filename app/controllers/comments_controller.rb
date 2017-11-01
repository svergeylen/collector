class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :upvote]
  before_action :check_access
  
  # GET /comments/1/edit
  def edit
    if (@comment.user_id != current_user.id)
      redirect_to posts_path, alert: 'Ce commentaire ne vous appartient pas' 
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    if (params[:comment][:user_id] == current_user.id.to_s)

      @comment = Comment.new(comment_params)
      @css_selector = "#comments-post-"+params[:comment][:post_id].to_s
      
      respond_to do |format|
        if @comment.save
          format.html { redirect_to posts_path, notice: 'Commentaire créé avec succès' }
          format.json { render :show, status: :created, location: @comment }
          format.js
        else
          format.html { render :new }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
          format.js
        end
      end
    else
      redirect_to posts_path, alert: 'Identifiant utilisateur erroné' 
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    if (@comment.user_id == current_user.id)
      respond_to do |format|
        if @comment.update(comment_params)
          format.html { redirect_to posts_url, notice: 'Commentaire modifié avec succès' }
          format.json { render :show, status: :ok, location: @comment }
        else
          format.html { render :edit }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to posts_url, alert: 'Ce commentaire ne vous appartient pas' 
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    if (@comment.user_id == current_user.id)
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Commentaire supprimé' }
        format.json { head :no_content }
      end
    else
      redirect_to posts_url, alert: 'Ce commentaire ne vous appartient pas' 
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

  private

    # Renvoi l'utilisateur à la page de garde s'il n'a pas accès à POST
    def check_access
      redirect_to root_url, alert: "Accès non autorisé" if !current_user.can?(:une)
    end 
    
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:message, :post_id, :user_id)
    end
end
