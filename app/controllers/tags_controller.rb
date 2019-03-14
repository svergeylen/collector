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
      # Si la liste est vide, on initialise la liste avec l'unique tag sélectionné
      if session[:active_tags].nil?
        session[:active_tags] = [ @tag.id ]
      else
        # Si l'option "add" est présenté, on veut ajouter ce tag aux tags actifs (ajout de critère de filtrage)
        if params[:add].present?
          # on ajoute le tag sélectionné en fin de liste sauf si déjà dans la liste
          unless session[:active_tags].include?(@tag.id)
            session[:active_tags] = session[:active_tags] + [ @tag.id ]  
          end
          
        # Sinon, on veut simplement aller au tag cliqué : active tags = tag sélectionné
        else
          # Si on clique sur un tag qui est déjà dans la liste, on ne garde que les tags amont à ce tag dans la liste (navigation breadcrumbs)
          if session[:active_tags].include?(@tag.id)
            i = session[:active_tags].index(@tag.id)
            session[:active_tags] = session[:active_tags][0..i]
          else
            session[:active_tags] = [ @tag.id ]
          end
        end
      end

      # Liste des tags actifs (breadcrumbs)
      @active_tags = Tag.find(session[:active_tags])

      # Parents éventuels du premier active tag
      if @active_tags.present?
        @elder_tags = Tag.find(@active_tags.first.elder_ids)
      end

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

      # Si le tag a des enfants, affichage des tags enfants dans la sidebar
      if @tag.tags.present?
        # S'il y a beaucoup de tags enfants, il faut afficher la barre alphabet et filtrer par lettre
        @navigate_option = (@tag.tags.count > 40)? true : false 
        case params[:letter]
          when "A".."W"
            @tags = @tag.children.where(letter: params[:letter])
          when "XYZ"
            @tags = @tag.children.where(letter: "X".."Z")
          when "#"
            @tags = @tag.children.where(letter: 0..9999999) 
          when "vide"
            @tags = @tag.children.where(letter: [nil, ""])
          else
            @tags = @tag.children
        end
        # Nombre de tag par colonne
        @tags_per_column = (@tags.count.to_f/4).ceil 

      end # @tag.tags.present?

      # Recherche des items qui possèdent tous les tags actifs
      items = Item.having_tags(session[:active_tags])
      @items = items.paginate(:page => params[:page], :per_page => 36)

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
    new_and_edit_actions
    
    if session[:active_tags].present?
      # On propose tous les tags actifs qui sont filtrants comme tags parents par défaut,
      # càd que le tag serait enfant du dernier tag cliqué
      @tag.parent_tag_names = Tag.where(id: session[:active_tags]).where(filter_items: true).pluck(:name).join(",") 
      # Reherche des valeurs par défaut les plus proches du dernier tag ajouté aux tags actifs
      last_tag = Tag.find(session[:active_tags].last)
      @tag.default_view = last_tag.default_view
      @tag.filter_items = last_tag.filter_items
    end
  end

  def create
    @tag = Tag.new(tag_params)
    
    if @tag.save
			if @tag.root_tag?
				redirect_to tags_path, notice: "Tag créé"
			else
				redirect_to @tag, notice: 'Tag créé' 
			end
    else
      render :new 
    end
  end

  def edit
    new_and_edit_actions
  end

  def update 
    if @tag.update(tag_params)
      redirect_to @tag, notice: 'Tag mis à jour'
    else
      render :edit
    end
  end

  def destroy
    tag_id = @tag.id
    tag_name = @tag.name
    if @tag.destroy
      session[:active_tags].delete(tag_id)
      redirect_back fallback_location: welcome_collector_path, notice: "Tag \"#{tag_name}\" supprimé"
    else
      redirect_back fallback_location: welcome_collector_path, alert: "Ce Tag ne peut pas être supprimé"
    end
  end

  # Permet de supprimer un tag actif de la liste des active_tags (en session utilisateur)
  def remove
    remove_id = params[:remove_id].to_i
    if remove_id && session[:active_tags].include?(remove_id)
      session[:active_tags] = session[:active_tags] - [ remove_id ]
      # Si l'utilisateur vient de supprimer le tag actif qui égale la page qu'il veut afficher
      if remove_id == @tag.id 
        if session[:active_tags].empty?
          # Tous les tags actifs ont été supprimés par l'utilisateur
          redirect_to welcome_collector_path, notice: "Vous avez supprimé tous les tags actifs"
        else
          # Il reste au moins un tag actif dans la liste, on choisit le dernier tag de la liste
          @tag = Tag.find(session[:active_tags].last)
          redirect_to @tag, notice: "Tag retiré des tags actifs et redirection vers #{@tag.name}"
        end
      else
        redirect_to @tag, notice: "Tag retiré des tags actifs"
      end
    else
      redirect_to @tag, alert: "Ce tag ne se trouve pas dans la liste des tags actifs"
    end
  end

  # Gestion des tags favoris
  def star
    # Si ce tag est déjà un favoris, il faut l'enlever
    if current_user.tags.include?(@tag)
      current_user.tags.delete(@tag)
      redirect_to @tag, notice: "Tag enlevé des favoris"
    else
      current_user.tags << @tag
      redirect_to @tag, notice: "Tag ajouté aux favoris"
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

  def new_and_edit_actions
    @tag_list = Tag.order(name: :asc).pluck(:name) - [ @tag.name ]
  end

  def tag_params
    params.require(:tag).permit(:name, :root_tag, :letter, :default_view, :filter_items, :parent_tag_names)
  end

end

