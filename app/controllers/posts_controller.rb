class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :delete_attachment, :remove_preview, :update, :destroy, :upvote]
  before_action :check_access

  # GET /posts
  # GET /posts.json
  def index

    # Eager loading comments
    # Pagination avec will_paginate
    @posts = Post.all.includes(:comments).order(updated_at: :desc).paginate(page: params[:page], per_page: 5)
    @current_page = params[:page].present? ? params[:page].to_s : "1"
    @next_page = (@current_page.to_i + 1).to_s

    # Mémorise l'heure du précédent affichage
    # Temporisation Une heure pour éviter de perdre la mise en évidence des nouveautés en raffraichissant la page
    if (current_user.displayed_la_une < (Time.now - 3600) )
      current_user.displayed_la_une = Time.now
      current_user.save
    end

    respond_to do |format|
      format.html
      format.js 
      format.atom
    end
  end

  def show
    @active_slide_id = params[:slide_id].to_i || 0
  end

  # GET /posts/1/edit
  def edit
    if (@post.user_id != current_user.id) && !current_user.can?(:admin)
      redirect_to posts_url, alert: 'Ce post ne vous appartient pas'
    end
  end

  # Supprimer un attachment du post
  def delete_attachment
    if @post.attachments.exists?(params[:attachment_id])
      @post.attachments.find(params[:attachment_id]).destroy
      @post.touch # Induit la purge du cache de ce post
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
        format.html { render :edit, alert: 'Erreur lors de la création du message' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if (@post.user_id == current_user.id) || current_user.can?(:admin)
      respond_to do |format|
        if @post.update(post_params)
          save_attachments

          format.html { redirect_to posts_path(:anchor => @post.id), notice: 'Message modifié avec succès' }
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
    if (@post.user_id == current_user.id) || current_user.can?(:admin)
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Message supprimé avec succès' }
        format.json { head :no_content }
      end
    else
      redirect_to posts_url, alert: 'Ce post ne vous appartient pas'
    end
  end

  # Gestion des votes sur les posts
  def upvote
    @post.increment_vote(current_user)
    @post.touch # purge du cache
  end

  # Génération d'une vignette pour les URL copiés/collés dans le formulaire post/new
  def preview
    url = params[:url]

    if (params[:youtube_id].present?)
      render partial: "shared/preview_youtube", locals: { youtube_id: params[:youtube_id] } 
    else
      page = LinkPreviewParser.parse(url)
      render partial: "shared/preview_link", locals: { title: page[:title], description: page[:description], url: url, image_url: page[:image] } 
    end
  end

  # Suppresion de la vignette
  def remove_preview
    @post.remove_preview
    render :edit, notice: "Vignette supprimée"
  end

  private

    # Crée les attachments correspondants aux (plusieurs) fichiers uploadés dans l'objet @post
    def save_attachments
      # Paperclip multiple upload of attachments on Post
      if params[:post][:attachments]
        @post.touch # induit la purge du cache pour ce post
        params[:post][:attachments].each { |attach|
          @post.attachments.create(image: attach, user_id: current_user.id)
        }
      end
    end

    # Renvoi l'utilisateur à la page de garde s'il n'a pas accès à POST
    def check_access
      redirect_to root_url, alert: "Accès non autorisé" if !current_user.can?(:une)
    end 

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:message, :user_id, :preview_title, :preview_description, :preview_url, :preview_image_url, :youtube_id)
    end
end
