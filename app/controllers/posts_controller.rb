class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :delete_attachment, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    # Eager loading comments
    @posts = Post.all.includes(:comments).order(updated_at: :desc).limit(30)
  end

  # GET /posts/1/edit
  def edit
    if (@post.user_id != current_user.id)
      redirect_to posts_url, alert: 'Ce post ne vous appartient pas'
    end
  end

  # Supprimer un attachment du post
  def delete_attachment
    if @post.attachments.exists?(params[:attachment_id])
      @post.attachments.find(params[:attachment_id]).destroy
      redirect_to edit_post_path(@post), notice: 'Pièce jointe supprimée' 
    else
      redirect_to edit_post_path(@post), alert: 'Erreur lors de la suppression de la pièce jointe' 
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        save_attachments

        format.html { redirect_to posts_path, notice: 'Message posté avec succès' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if (@post.user_id == current_user.id)
      respond_to do |format|
        if @post.update(post_params)
          save_attachments

          format.html { redirect_to posts_path, notice: 'Message modifié avec succès' }
          format.json { render :show, status: :ok, location: @post }
        else
          format.html { render :edit }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to posts_url, alert: 'Ce post ne vous appartient pas'
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    if (@post.user_id == current_user.id)
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Message supprimé avec succès' }
        format.json { head :no_content }
      end
    else
      redirect_to posts_url, alert: 'Ce post ne vous appartient pas'
    end
  end


  private

    # Crée les attachments correspondants aux (plusieurs) fichiers uploadés dans l'objet @post
    def save_attachments
      # Paperclip multiple upload of attachments on Post
      if params[:post][:attachments]
        params[:post][:attachments].each { |attach|
          @post.attachments.create(image: attach, user_id: current_user.id)
        }
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:message, :user_id)
    end
end
