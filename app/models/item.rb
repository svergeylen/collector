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

	# Temporaire pour la migration de l'ancien site.
	# Ajout d'un lien vers l'ancienne table items_tags pour lire les auteurs des BD !
	has_and_belongs_to_many :old_tags, source: :items_tags, class_name: 'Tag'

	attr_accessor :series
	attr_accessor :auteurs
	attr_accessor :rangement

	# Renvoie les tags de l'item après avoir soustrait les active tags
	def different_tags(active_tag_ids)
		ids = self.tag_ids - active_tag_ids
		return Tag.find(ids)
	end

  	# Renvoie les Items correspondants à l'array de tags donné
  	def self.having_tags(ar_tags)
  		# Item.where(id: Ownertag.where(tag_id: ar_tags, owner_type: "Item").group(:owner_id).count.select{|owner_id, value| value >= ar_tags.size }.keys)
  		# Item.where(id: Ownertag.where(tag_id: ar_tags, owner_type: "Item").group(:owner_id).count.select{|owner_id, value| value >= ar_tags.size }.keys)
   
    	# DANIEL -> ICI : ajouter .where(tag.filter_items = true)
    	# Item.where(id: Ownertag.where(tag_id: ar_tags, owner_type: "Item").group(:owner_id).count.select{|owner_id, value| value >= ar_tags.size }.keys)
    	# Item.includes(:tags).where(tags: {name: ar_tags, filter_items: false})
    	# Item.includes(:tags).where(tags: {id: ar_tags, filter_items: false})
    	# Je pense que c'est filter_items: true car c'est true par défaut et false pour le tag "Séries"
    	# Item.includes(:tags).where(tags: {id: ar_tags, filter_items: true})

    	# Tentatives St :
    	# applicable_tag_ids = Tag.where(id: ar_tags).where(filter_items: true).pluck(:id)
    	# Item.includes(:tags).where(tags: {id: applicable_tag_ids})
    	# ne fonctionne pas car il renvoie tous les items qui sont bd OU qui sont Thorgal, alors qu'on veut un AND
    	applicable_tag_ids = Tag.where(id: ar_tags).where(filter_items: true).pluck(:id)
    	ownertags = Ownertag.where(tag_id: applicable_tag_ids, owner_type: "Item").group(:owner_id).count.select{|owner_id, value| value >= applicable_tag_ids.size }
    	Item.where(id: ownertags.keys)
    	
  	end


  	# def series
  	# 	series_tag = Tag.where(name:"Séries").first
  	# 	return self.tags.select { |t| t.parent_tags.include?(series_tag) }
  	# end

  	# def auteurs
  	# end

  	# def rangement
  	# end

  	# Renvoie seulement les tags d'un item pour un parent spécifique donné
  	def tags_with_parent(parent_tag)
		return self.tags.select { |t| t.parent_tags.include?(parent_tag) }
  	end

  	# Met à jour les tags de l'item, mais uniquement les tags qui sont dans le parent donné
  	def update_tags_with_parent(input_string, parent_tag)
  		# On crée deux listes de string contenant les tags à comparer
  		current_tag_names   = self.tags_with_parent(parent_tag).map(&:name)
  		new_tag_names = input_string.present? ? input_string.split(",").map{ |el| el.strip } : []
  		
  		# On réalise la différence entre les tags existants et nouveaux --> à ajouter
  		names_to_create = new_tag_names - current_tag_names
		parent_tag.create_children(names_to_create)
  		
  		# On réalise la différence entre les tags existants et ceux retirés dans la liste --> à supprimer
  		names_to_destroy = current_tag_names - new_tag_names
  		self.tags.destroy(Tag.where(name: names_to_destroy))
  	end

  	# # Ajoute les tags donnés comme liste de strings séparés par des virgules et/ou crée les nouveaux tags
  	# def add_tags_by_name(tag_names, parent_tag = nil)
  	# 	tag_names.each do |tag_name|
  	# 		# Recherche d'un tag existant sur base du nom string donné (ou création)
  	# 		tag = Tag.find_or_create_by(name: tag_name)
  	# 		# Si un parent_tag est donné, on relie ces nouveaux tags au parent_tag
			# if parent_tag.present?
			# 	tag.parent_tags << parent_tag unless tag.parent_tags.include?(parent_tag)
			# 	tag.save
			# end
			# # Association des tags à l'item, sans faire de doublon
			# self.tags << tag unless self.tags.include?(tag)
  	# 	end
  	# end

	# Renvoie true si l'utilisateur possède cet item
	def is_owned_by?(user_id)
		return self.itemusers.collect(&:user_id).include?(user_id)
	end

	# Renvoie le Itemuser de l'utiliateur donné
	def iu(user_id)
		return self.itemusers.where(user_id: user_id).limit(1).first
	end

	# Renvoie le nombre d'items identiques possédés par l'utilisateur donné
	def quantity_for(user_id)
		iu = self.iu(user_id)
		if iu.present?
			return iu.quantity
		else
			return 0
		end
	end

	# Modifie la quantité posédée par l'utilisateur donné
	def update_quantity(value, user_id)
		delta = value.to_i
		iu = self.iu(user_id)
	    if iu.present?
	      iu.quantity = [ (iu.quantity + delta), 0].max
	      iu.save
	    else
	    	# Si l'utilisateur n'a pas l'item ET que l'on veut diminuer la quantité... autant ne rien faire
	    	if (delta > 0)
	      		iu = Itemuser.create!(item_id: self.id, user_id: user_id, quantity: delta)
	      	end
	    end
	    return iu
	end

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

	# Recherche les items contenant le mot clé donné
	def self.search(keyword)
		if keyword.present?
		  where('name LIKE ?', "%#{keyword}%").order(name: :asc)
		else
		  all
		end
	end
end
