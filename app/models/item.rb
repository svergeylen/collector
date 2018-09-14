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

	# Renvoie les tags de l'item après avoir soustrait les active tags
	def different_tags(active_tag_ids)
		ids = self.tag_ids - active_tag_ids
		return Tag.find(ids)
	end

  	# Renvoie les Items correspondants à l'array de tags donné
  	def self.having_tags(ar_tags)
    	#Item.where(id: Ownertag.where(tag_id: ar_tags, owner_type: "Item").group(:owner_id).count.select{|owner_id, value| value >= ar_tags.size }.keys)
    	# DANIEL -> ICI : ajouter .where(tag.filter_items = true)
    	
    	Item.where(id: Ownertag.where(tag_id: ar_tags, owner_type: "Item").group(:owner_id).count.select{|owner_id, value| value >= ar_tags.size }.keys)

    	# Item.includes(:tags).where(tags: {name: ar_tags, filter_items: false})
  	end

  	# Màj les tag de l'item (devrait être géré par rails, mais unpermitted parameters systématiquement)
  	def update_tag_ids(tag_ids)
  		self.tag_ids = tag_ids
  	end


	# Renvoie les id des items précédents et suivants dans la serie triée (sorted_items)
	def next_and_previous_ids
		# Chargement de la série en entier pour connaitre les éléments de la liste par numéro
		items = self.series.sorted_items
		
		# Récupération de l'index dans la collection correspondant à l'item self
		my_index = items.index { |item| item.id == self.id }
		
		# Récupération des index puis des ID correspondants  dans la collection
		previous_index = (my_index <= 0) ? nil : my_index - 1
		previous_id = items.at(previous_index).id if !previous_index.nil?
		
		next_index = (my_index >= (items.length-1) )? nil : my_index + 1
		next_id = items.at(next_index).id if !next_index.nil?

		return { previous: previous_id, next: next_id }
	end

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

	# Donne le nom de l'item précédé du nom de sa série et de son numéro si présent
	def friendly_name
		ret = self.series.name
		ret += " (n°"+self.friendly_number+")" if self.number.present?
		ret += " - " + self.name
		return ret
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
