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
      # Ajout du tag actif dans la liste de tags actifs sans faire de doublon
      if session[:active_tags].nil?
        session[:active_tags] = [ @tag.id ]
      else
        if session[:active_tags].include?(@tag.id)
          # Le tag est dans la liste et l'utilisateur reclique dessus -> on le déplace à la fin de l'array
          # De cette faon, le titre affiché correspond toujours au dernier tags de l'array (plus lisible)
          session[:active_tags] = session[:active_tags] - [ @tag.id ] 
        end
        # Dans les deux cas, on ajoute le tag sélectionné en fin d'array
        session[:active_tags] = session[:active_tags] + [ @tag.id ] 
        
      end

      @active_tags = Tag.find(session[:active_tags])

      @child_tags = @tag.children

      # Si le tag a des enfants, il faut afficher les tags enfants (navigation)
      # Si le tag n'a plus d'enfant, on peut afficher les items.
      if @child_tags.empty?

        # Recherche des items qui possèdent tous les tags actifs
        @items = Item.having_tags(session[:active_tags])

        # Choix de la vue 
        if params[:view].present?
          @view = params[:view]
        else
          if @tag.default_view.blank?
            @view = "list"
          else
            @view = @tag.default_view
          end 
        end

      end

      # Formulaire d'ajout d'item en bas de page
      @new_item = Item.new

    end  #if @tag
  end

  def new
    @tag = Tag.new
    
    # Cherche des tags à proposer pour populer le champ parent_tags
    # proposal = Tag.where(id: get_session_breadcrumbs).where(optional: false).map(&:id)
    # On propose uniquement le premier parent pour éviter la confusion...
    # sinon, on se retrouve avec l'item à tous les niveaux de la hiérarchie (c'est nul)
    @tag.parent_tag_ids = [ params[:parent_tag].to_s ]
  end

  def create
    @tag = Tag.new(tag_params)
    
    if @tag.save
      @tag.update_parent_tags(params[:tag][:parent_tags])
			if @tag.root_tag?
				redirect_to tags_path, notice: "Tag créé"
			else
				redirect_to @tag, notice: 'Tag créé' 
			end
    else
      render :new 
      # ICI BUG : lorsqu'il y a une erreur de validation, on perd la valeur de @tag.parent_tag_ids ???
    end
  end

  def edit
  end

  def update
    @tag.update_parent_tags(params[:tag][:parent_tags])
    
    if @tag.update(tag_params)
      redirect_to @tag, notice: 'Tag mis à jour'
    else
      render :edit
    end
  end

  def destroy
    # BUG : Il faut prévoir le déplacement des tags enfants qui deviennent orphelins vers ?? (root_tag=true ?)
    if @tag.destroy
      redirect_to tags_path, notice: "Tag supprimé"
    else
      redirect_to tags_path, alert: "Ce Tag ne peut pas être supprimé"
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
          redirect_to tags_path, notice: "Vous avez supprimé tous les tags acitfs"
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

  def tag_params
    params.require(:tag).permit(:name, :root_tag, :letter, :default_view, :view_alphabet, :filter_items)
  end

end
