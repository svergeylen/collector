class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :remove, :destroy]

  # Liste des tags pour gestion banque de données
  def index
    per_page = 40
    case params[:letter]
      when "A".."W"
        @tags = Tag.where(letter: params[:letter]).order(name: :asc).paginate(page: params[:page], per_page: per_page)
      when "XYZ"
        @tags = Tag.where(letter: "X".."Z").order(name: :asc).paginate(page: params[:page], per_page: per_page)
      when "#"
        @tags = Tag.where(letter: 0..9999999).order(name: :asc).paginate(page: params[:page], per_page: per_page)
      when "vide"
        @tags = Tag.where("letter is NULL OR letter is ''").order(name: :asc).paginate(page: params[:page], per_page: per_page)
      when "orphelins"
        # Recherche de tags orphelins (suppression de leur parent ou erreur database)
        all_tags = Tag.where(root_tag: false).map(&:id)
        all_tags_with_parent = Ownertag.where(owner_type: "Tag").map(&:tag_id)
        orphan_ids = all_tags - all_tags_with_parent
        @tags = Tag.where(id: orphan_ids).order(name: :asc).paginate(page: params[:page], per_page: per_page)
      else
        # pas d'action. @tags = nil
        @tag_counter = Tag.all.count 
    end
  end

  # Affichage d'un seul tag, de ses tags enfants ou des items qu'il contient
  def show

    if @tag
      # Si la liste est vide, on initialise la liste avec l'unique tag sélectionné
      if session[:active_tags].nil?
        session[:active_tags] = [ @tag.id ]
      else
        # Si on clique sur un tag qui est déjà dans la liste, on ne garde que les tags amont à ce tag dans la liste (navigation breadcrumbs)
        if session[:active_tags].include?(@tag.id)
          i = session[:active_tags].index(@tag.id)
          session[:active_tags] = session[:active_tags][0..i]
        else
          # Sinon, on ajoute le tag sélectionné en fin de liste
          session[:active_tags] = session[:active_tags] + [ @tag.id ] 
        end
        
      end

      @active_tags = Tag.find(session[:active_tags])

      # Si le tag a des enfants, il faut afficher les tags enfants (navigation), pas d'items
      if @tag.tags.present?

        # S'il y a beaucoup de tags enfants, il faut afficher la barre alphabet et filtrer par lettre
        @view_alphabet = (@tag.tags.count >= 40)? true : false
          
        per_page = 40
        case params[:letter]
          when "A".."W"
            @tags = @tag.children.where(letter: params[:letter]).paginate(page: params[:page], per_page: per_page)
          when "XYZ"
            @tags = @tag.children.where(letter: "X".."Z").paginate(page: params[:page], per_page: per_page)
          when "#"
            @tags = @tag.children.where(letter: 0..9999999).paginate(page: params[:page], per_page: per_page)
          when "vide"
            @tags = @tag.children.where("letter is NULL OR letter is ''").paginate(page: params[:page], per_page: per_page)
          else
            @tags = @tag.children.paginate(page: params[:page], per_page: per_page)
        end
      
      # Si le tag n'a plus d'enfant, on peut afficher les items.
      else
        # Recherche des items qui possèdent tous les tags actifs
        @items = Item.having_tags(session[:active_tags])

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
      end

    end  #if @tag
  end

  def new
    @tag = Tag.new
    new_and_edit_actions
    # Reherche des tags à proposer pour populer le(s) champ(s) parent_tags
    @tag.parent_tag_ids = [ params[:parent_tag].to_s ]
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
          redirect_to tags_path, notice: "Vous avez supprimé tous les tags actifs"
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

  private
  
  def set_tag
    @tag = Tag.find(params[:id])
  end

  def new_and_edit_actions
    @tag_list = Tag.order(name: :asc).pluck(:name)
  end

  def tag_params
    params.require(:tag).permit(:name, :root_tag, :letter, :default_view, :view_alphabet, :filter_items, :parent_tag_names)
  end

end
