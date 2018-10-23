class Item < ApplicationRecord
	enum rails_view: [ :general, :bd]

	has_many :ownertags,    dependent:  :destroy, as: :owner
	has_many :tags,         through:    :ownertags
	accepts_nested_attributes_for :tags

	has_many :itemusers
	has_many :users,        through:    :itemusers
	belongs_to :adder,      class_name: "User"

	has_many :attachments,  as:         :element,   dependent: :destroy
	accepts_nested_attributes_for :attachments

	acts_as_votable # les users peuvent mettre des likes sur les items
	
	validates :name, presence: true
	validates :adder_id, presence: true

	after_save :add_root_tag

	# --------------------- VIRTUAL ATTRIBUTES ---------------------------------------------------------------------------

	attr_writer :tag_names 			# tags form item générique
	attr_writer :tag_series			# Series form item BD
	attr_writer :tag_auteurs		# Auteurs form item BD
	attr_writer :tag_rangements		# Rangements form item BD
	before_save :save_tags
	before_save :save_series
	before_save :save_auteurs
	before_save :save_rangements

	# Donne la liste de tags de l'item au format string séparé par une virgule
	def tag_names
		@tag_names || tags.pluck(:name).join(", ")
	end

	# Before_save : Sauvegarde les tags donnés dans une liste de string séparée par des virgule en objets Tag
	def save_tags
		if @tag_names
			tags = []
			@tag_names.split(",").each do |name| 
				logger.debug "---> "+name.to_s
				name = name.strip
				next if name==""
				new_tag = Tag.where(name: name).first_or_create!
				# BUG ici si on tente de créer un tag qui porte le même nom d'auteur sans les majuscules
				# car le tag n'est pas créé et le save foire
				tags << new_tag # unless tags.include?(new_tag)
			end
			# J'écrase tous les tags existants. C'est différent de la méthode add_tags qui ajoute des tags
			self.tags = tags
		end
	end

	# Donne la liste de series de l'item au format string séparé par une virgule
	def tag_series
		@tag_series || tags_with_parent("Séries").pluck(:name).join(", ")
	end
	
	# Before_save : Sauvegarde les series donnés dans une liste de string séparée par des virgule en objets Tag
	def save_series
		if @tag_series
			self.update_tags_with_parent(@tag_series.split(","), "Séries")
		end
	end

	# Donne la liste de auteurs de l'item au format string séparé par une virgule
	def tag_auteurs
		@tag_auteurs || tags_with_parent("Auteurs").pluck(:name).join(", ")
	end
	
	# Before_save : Sauvegarde les auteurs donnés dans une liste de string séparée par des virgule en objets Tag
	def save_auteurs
		if @tag_auteurs
			self.update_tags_with_parent(@tag_auteurs.split(","), "Auteurs")
		end
	end

	# Donne la liste de rangements de l'item au format string séparé par une virgule
	def tag_rangements
		@tag_rangements || tags_with_parent("Rangements").pluck(:name).join(", ")
	end
	
	# Before_save : Sauvegarde les rangements donnés dans une liste de string séparée par des virgule en objets Tag
	def save_rangements
		if @tag_rangements
			self.update_tags_with_parent(@tag_rangements.split(","), "Rangements")
		end
	end

	# Ajout d'un tag d'office à l'item, correspondant à son item_type
	# Si le tag correspondant n'est pas trouvé, tant pis, c'est mieux que rien...
	def add_root_tag
      list_item_types = { 	"bd" => "Bandes dessinées", 
      						"bonsai" => "Bonsais", 
      						"jeu" => "Jeu de société", 
      						"livre" => "Livres", 
      						"modelisme" => "Modélisme" }
      if self.item_type.present? and self.item_type != "item"
      	results = Tag.where(name: list_item_types[self.item_type])
      	if results.present?
      		tag = results.first 
	      	self.tags << tag unless self.tags.include?(tag)
	    end
	  end
	end


	# --------------------- TAGS ---------------------------------------------------------------------------

	# Ajoute l'array de tag_names à l'item sans créer de doublon. Crée les tags si inexistants.
	# Différent de save_tags qui écrase les tags existants par les tags donnés.
	def add_tags(tag_names_array)
		tag_names_array.each do |tag_name|
			tag_name = tag_name.strip
			if tag_name!=""
				tag = Tag.where(name: tag_name).first_or_create!
				self.tags << tag unless self.tags.include?(tag)
			end
		end
	end

	# Supprime l'association entre l'item et le tableau de tag_names donné
	def remove_tags(tag_names_array)
		tag_names_array.each do |tag_name|
			tag_name = tag_name.strip
			if tag_name!=""
				tag = Tag.find_by(name: tag_name)
				self.tags.delete(tag) if tag.present?
			end
		end
	end

	# Renvoie les tags de l'item après avoir soustrait les active tags
	# Deprecated pour raison de performances
	# def different_tags(active_tag_ids)
	# 	ids = self.tag_ids - active_tag_ids
	# 	return Tag.find(ids)
	# end

	# Renvoie les Items correspondants à l'array de tag_ids donné
	def self.having_tags(ar_tags, limit: nil)
	  	# On sélectionne dans les tags donnés uniquement ceux qui doivent filtrer les items
	  	applicable_tag_ids = Tag.where(id: ar_tags).where(filter_items: true).pluck(:id)
	  	# On sélectionne les items qui correspondent à ces tags filtrants en comptant si chaque item est repris autant de fois que le nombre de tags filtrants donné
	  	# Si il y a deux tags filtrants donnés, il faut que ownertags contiennent 2 lignes pour cet item (une ligne pour chaque tag différent)
	  	ownertags = Ownertag.where(tag_id: applicable_tag_ids, owner_type: "Item").group(:owner_id).count.select{|owner_id, value| value == applicable_tag_ids.size }
	  	
	  	if (limit.present?)
	 		# Si une page est demandée, on impose la pagination. L'ordre n'a pas de sens vu qu'on paginate avant de mettre en ordre (performances :-( )
	  		Item.includes(:tags, itemusers: [:user]).where(id: ownertags.keys).order(updated_at: :desc).limit(limit)
	  	else
	  		# Sinon, on charge tous les items du tag
			Item.includes(:tags, itemusers: [:user]).where(id: ownertags.keys).sort_by{ |a| [a.number.to_f, a.name] }
		end
	end

	# Renvoie seulement les tags d'un item pour un parent spécifique donné
	def tags_with_parent(parent_name)
		if Tag.exists?(name: parent_name)
			parent = Tag.find_by(name: parent_name)
			ids = Ownertag.where(tag_id: self.tag_ids).where(owner_id: parent.id).where(owner_type: "Tag").pluck(:tag_id)
			return Tag.find(ids)
		else
			return nil
		end
	end

	# Met à jour les tags de l'item, mais uniquement les tags qui sont dans le parent donné
	# Renvoie false en cas d'erreur. True si la màj s'est déroulée avec succès
	def update_tags_with_parent(array_tag_names, parent_tag_name)
		if Tag.exists?(name: parent_tag_name)
			parent_tag = Tag.find_by(name: parent_tag_name)
			# On crée deux listes de string contenant les tags à comparer
			current_tag_names   = self.tags_with_parent(parent_tag_name).map(&:name)
			new_tag_names = array_tag_names.present? ? array_tag_names.map{ |el| el.strip } : []
			
			# On réalise la différence entre les tags existants et nouveaux --> à ajouter à l'item
			names_to_create = new_tag_names - current_tag_names
			created_tags = parent_tag.create_children(names_to_create)
			self.tags << created_tags
			
			# On réalise la différence entre les tags existants et ceux retirés dans la liste --> à supprimer de l'item
			names_to_destroy = current_tag_names - new_tag_names
			self.tags.destroy(Tag.where(name: names_to_destroy))
			# les names_to_destroy sont automatiquement désassociés de l'item via le destroy
			return true
		else
			return false
		end
	end


	# ------------------ POSSESSION de l'ITEM ----------------------------------------------------------------

	# Renvoie true si l'utilisateur possède cet item
	def is_owned_by?(user_id)
		return (self.quantity_for(user_id) > 0)
	end

	# Renvoie le nombre d'items identiques possédés par l'utilisateur donné
	def quantity_for(user_id)
		iu = self.itemusers.where(user_id: user_id).first
		if iu.present?
			return iu.quantity
		else
			return 0
		end
	end

	# --------------------  CHAMPS de l'ITEM -------------------------------------------------------------


	# Renvoie le string du numéro de l'item (integer ou float suivant les cas)
	def friendly_number
		if self.number.present?
			if (self.number.round(0) == self.number)
				ret = self.number.round(0).to_s
			else
				ret = self.number.to_s
			end
		end
		return ret
	end


	# --------------------------- RECHERCHE -------------------------------------------------------------

	# Recherche les items contenant le mot clé donné
	def self.search(keyword)
		keyword = keyword.downcase
		if keyword.present?
		  where('name LIKE ?', "%#{keyword}%").order(name: :asc)
		else
		  all
		end
	end
end
