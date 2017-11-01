class Item < ApplicationRecord
	belongs_to :series

	#has_many :itemtags, dependent: :delete_all
	has_and_belongs_to_many :tags #, through: :itemtags

	has_many :itemusers
	has_many :users, through: :itemusers
	belongs_to :adder, class_name: "User"

	has_many :attachments, as: :element, dependent: :destroy
	accepts_nested_attributes_for :attachments

	acts_as_votable # les users peuvent mettre des likes sur les items
	
	validates :name, presence: true
	validates :series_id, presence: true
	validates :adder_id, presence: true

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


	# Donne le total des notes pour cette series, au travers des likes de chaque item qu'elle contient
	# def likes_count
	# 	self.likes.sum(:note)
	# end

	# # Ajoute un like ou edite le like existant
	# def add_or_update_like(user_id, note, remark)
	# 	note = 1 if note.nil?
	# 	like = self.like_from(user_id)
	# 	if like.present?
	# 		like.update(note: note, remark: remark)
	# 		like.save # ?
	# 	else
	# 		like = self.likes.build(user_id: user_id, item_id: self.id, note: note, remark: remark)
	# 		like.save
	# 	end
	# 	return like
	# end
	
	# # Renvoie le like du user donné
	# def like_from(user_id)
	# 	return self.likes.where(user_id: user_id).first
	# end

	# # Renvoie true si l'élément est déjà marqué comme like par l'utilisateur (note >= 1)
	# def is_liked_by?(user_id)
	# 	like = self.likes.where(user_id: user_id).first
	# 	if like.present? and like.note.present? and (like.note > 0) 
	# 		return true
	# 	else
	# 		return false
	# 	end		
	# end

	# Liste les tags de l'item (auteurs, édition, mots-clés)
	def tags_list
		self.tags.map(&:name).join(", ")
	end

	# Associe l'item à un auteur exitant ou crée un nouvel auteur
	def tags_list=(names)
		self.tags = names.split(",").map do |n|
		  Tag.where(name: n.strip.downcase, category_id: self.series.category_id).first_or_create!
		end
	end

	# Recherche les items contenant le mot clé donné
	def self.search(keyword)
		if keyword.present?
		  where('name LIKE ?', "%#{keyword}%")
		else
		  all
		end
	end
end
