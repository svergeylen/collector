class TagsController < ApplicationController
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
      when "vide"
        @tags = Tag.includes(:items).where(letter: [nil, ""]).order(name: :asc).paginate(page: params[:page], per_page: per_page)
      when "orphelins"
        # Recherche de tags orphelins (suppression de leur parent ou erreur database)
        all_tags = Tag.where(root_tag: false).map(&:id)
        all_tags_with_parent = Ownertag.where(owner_type: "Tag").map(&:tag_id)
        orphan_ids = all_tags - all_tags_with_parent
        @tags = Tag.includes(:items).where(id: orphan_ids).order(name: :asc).paginate(page: params[:page], per_page: per_page)
      else
        # pas d'action. @tags = nil
        @tag_counter = Tag.all.count 
    end
  end

  # Affichage d'un seul tag, de ses tags enfants ou des items qu'il contient
  def show
    @max_items = 24 # Nombre d'items max à charger si encore des tags enfants présents

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

      # Liste des tags actifs (breadcrimbs)
      @active_tags = Tag.find(session[:active_tags])

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
      @rangements_list = Tag.find_by(name: "Rangements").children.pluck(:name)
      @tag_list = Tag.order(name: :asc).pluck(:name)

      # Si le tag a des enfants, affichage des tags enfants dans la sidebar
      if @tag.tags.present?
        # S'il y a beaucoup de tags enfants, il faut afficher la barre alphabet et filtrer par lettre
        tags_per_page = 40
        @view_alphabet = (@tag.tags.count >= tags_per_page)? true : false 
        case params[:letter]
          when "A".."W"
            @tags = @tag.children.where(letter: params[:letter]).paginate(page: params[:page], per_page: tags_per_page)
          when "XYZ"
            @tags = @tag.children.where(letter: "X".."Z").paginate(page: params[:page], per_page: tags_per_page)
          when "#"
            @tags = @tag.children.where(letter: 0..9999999).paginate(page: params[:page], per_page: tags_per_page)
          when "vide"
            @tags = @tag.children.where(letter: [nil, ""]).paginate(page: params[:page], per_page: tags_per_page)
          else
            @tags = @tag.children.paginate(page: params[:page], per_page: tags_per_page)
        end
     
        # On charge les derniers items modifiés (ex : Bd/Bonsai : on affiche les dernières modifs)
        @items = Item.having_tags(session[:active_tags], limit: @max_items)

      # Si pas de tags enfant, affichage des items en pleine page (pas de sidebar)
      else
        # Recherche des items qui possèdent tous les tags actifs
        @items = Item.having_tags(session[:active_tags])
        # Recherche du numéro suivant en cas d'ajout
        @next_number = 1
        @items.each do |item| 
          if item.number.present? and item.number >= @next_number
            @next_number = item.number + 1
          end
        end

      end  # if tag.tags present?
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
    # BUG : Il faut prévoir le déplacement des tags enfants qui deviennent orphelins vers ?? (root_tag=true ?)
    tag_id = @tag.id
    if @tag.destroy
      session[:active_tags].delete(tag_id)
      redirect_to last_tag_path, notice: "Tag supprimé"
    else
      redirect_to last_tag_path, alert: "Ce Tag ne peut pas être supprimé"
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


  private
  
  def set_tag
    @tag = Tag.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    redirect_to tags_path, alert: "Ce tag n'existe plus dans la banque de données"
  end

  def new_and_edit_actions
    @tag_list = Tag.order(name: :asc).pluck(:name) - [ @tag.name ]
  end

  def tag_params
    params.require(:tag).permit(:name, :root_tag, :letter, :default_view, :filter_items, :parent_tag_names)
  end

end
