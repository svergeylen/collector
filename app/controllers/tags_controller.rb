class TagsController < ApplicationController
  require 'will_paginate/array'

  before_action :set_tag, only: [:show, :edit, :update, :remove, :destroy, :star]

  # Liste des tags pour gestion banque de données
  # Attention, ne pas confondre avec welcome > Collector
  def index
    per_page = 50
    case params[:letter]
      when "A".."W"
        @tags = Tag.includes(:items).where(letter: params[:letter].upcase).order(name: :asc).paginate(page: params[:page], per_page: per_page)
      when "XYZ"
        @tags = Tag.includes(:items).where(letter: "X".."Z").order(name: :asc).paginate(page: params[:page], per_page: per_page)
      when "#"
        @tags = Tag.includes(:items).where(letter: 0..9999999).order(name: :asc).paginate(page: params[:page], per_page: per_page)
      when "Vide"
        @tags = Tag.includes(:items).where(letter: [nil, ""]).order(name: :asc).paginate(page: params[:page], per_page: per_page)
      when "Racine"
        # Recherche de tags orphelins (suppression de leur parent ou erreur database)
        all_tags = Tag.all.map(&:id)
        all_tags_with_parent = Ownertag.where(owner_type: "Tag").map(&:tag_id)
        orphan_ids = all_tags - all_tags_with_parent
        @tags = Tag.includes(:items).where(id: orphan_ids).order(name: :asc).paginate(page: params[:page], per_page: per_page)
      else
        # pas d'action. @tags = nil
        @tag_counter = Tag.all.count 
    end

    # Options pour les actions en bas de page (selectize)
    @tag_list = Tag.order(name: :asc).pluck(:name)

  end

  # Affichage d'un seul tag, de ses tags enfants ou des items qu'il contient
  def show
    if @tag
      # Choix de la vue pour l'affichage des items
      if params[:view].present?
        @view = params[:view]
      else
        if @tag.default_view.blank?
          @view = "list"
        else
          @view = @tag.default_view
        end 
      end

      # Options pour les actions en bas de page (selectize)
      @tag_list = Tag.order(name: :asc).pluck(:name)

      # Choix de l'ordre dans lequel afficher les items
      if params[:order].present?
        @order = params[:order]
      else
        @order = @tag.root_tag? ? "date" : "number"
      end

      # Recherche des items qui possèdent tous les tags actifs
      items = @tag.items #order(@order)
      @items = items.paginate(page: params[:page], per_page: 36)

      # Recherche des données intéressantes en cas de création de nouvel item
      # Recherche du numéro suivant
      next_number = 1
      @items.each do |item| 
        if item.number.present? and item.number >= next_number
          next_number = item.number + 1
        end
      end
      # Mémorisation des tags du dernier item pour proposer des tags (ex : les auteurs)
      if @items.present?
        proposed_tag_ids = @items.last.tags.where(filter_items: true).pluck(:id)
        # Idée > Ajouter les actives_tags dans proposed_tag_ids (+uniq) ?
        item_type = @items.last.item_type
      end
      # Création d'un hash ajouté au link_to "Item>New"
      @new_item_options = {number: next_number, item_type: item_type, tag_ids: proposed_tag_ids}

      

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


  # Gestion des actions réalisées sur une liste de tags.
  # params contient la liste des tag id qu'il faut modifier
  def actions 
    if params[:tag_ids].nil?
      redirect_to tags_path, alert: 'Veuillez sélectionner des tags'
    else
      # On ajoute les items sélectionnés dans la collection de l'utilisateur courant
      if params[:add_parent].present?
        params[:tag_ids].each do |tag_id|
          Tag.find(tag_id).add_parent_tag(params[:tag_names])
        end
        redirect_to tags_path, notice: 'Tag Parent ajouté aux tags sélectionnés'
      end
    end # if item_ids.empty?
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
    params.require(:tag).permit(:name, :root_tag, :letter, :default_view, :filter_items, :parent_tag_names)
  end

end

