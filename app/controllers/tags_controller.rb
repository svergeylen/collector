class TagsController < ApplicationController
  require 'will_paginate/array'

  before_action :set_tag, only: [:show, :edit, :update, :remove, :destroy, :star]

  # Liste des tags pour gestion banque de données
  # Attention, ne pas confondre avec welcome > Collector
  def index
    per_page = 50
		@tags = Tag.includes(:items).order(name: :asc).paginate(page: params[:page], per_page: per_page)
	  # Options pour les actions en bas de page (selectize)
    @tag_list = Tag.order(name: :asc).pluck(:name)

  end

  # Affichage d'un seul tag, de ses tags enfants ou des items qu'il contient
  def show
    if @tag
      # Recherche des items qui possèdent tous les tags actifs
      items = @tag.items #order(@order)
      @items = items.paginate(page: params[:page], per_page: 100)
    end # if tag
  end # show

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    
    if @tag.save
			redirect_to @tag, notice: 'Tag créé' 
    else
      render :new 
    end
  end

  def edit
    
  end

  def update 
    if @tag.update(tag_params)
      redirect_to @tag, notice: 'Tag mis à jour'
    else
      render :edit
    end
  end

  def destroy
    if @tag.destroy
      redirect_to welcome_collector_path, notice: "Tag supprimé"
    else
      redirect_to welcome_collector_path, alert: "Ce Tag ne peut pas être supprimé"
    end
  end


 private
  
  def set_tag
    if Tag.exists?(params[:id])
      @tag = Tag.find(params[:id])
    else
      back = request.env["HTTP_REFERER"] || welcome_collector_path
      redirect_to back, alert: "Tag introuvable. Il a probablement été supprimé."
    end
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

end

