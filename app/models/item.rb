class Item < ApplicationRecord
	belongs_to :series

	has_many :itemauthors, :dependent => :destroy
	has_many :authors, through: :itemauthors

	has_many :likes, :dependent => :destroy
	has_many :likers, through: :likes

	validates :name, presence: true, length: { minimum: 2 }
	validates :series_id, presence: true

	# ajoute un like ou edite le like existant
	def add_or_update_like(user_id, note, remark)
		note = 1 if note.nil?
		like = self.likes.where(user_id: user_id).limit(1)
		if like.present?
			like.update(note: note, remark: remark)
		else
			like = self.likes.build(user_id: user_id, item_id: self.id, note: note, remark: remark)
			like.save
			puts "SAVE !"
		end
		return like
	end

	# REnvoie true si l'élément est déjà marqué comme like par l'utilisateur (note >= 1)
	def is_liked_by?(user_id)
		like = self.likes.where(user_id: user_id).first
		if like.present? and like.note.present? and (like.note > 0) 
			return true
		else
			return false
		end		
	end

	# Liste les auteurs de l'item
	def authors_list
		authors.map(&:name).join(", ")
	end

	# Associe l'item à un auteur exitant ou créé un nouvel auteur
	def authors_list=(names)
		self.authors = names.split(",").map do |n|
		  Author.where(name: n.strip).first_or_create!
		end
	end

	# Recherche les items contenant le mot clé donné
	def self.search(keyword)
		if keyword
		  where('name LIKE ?', "%#{keyword}%")
		else
		  scoped
		end
	end

end
