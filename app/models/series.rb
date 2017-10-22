class Series < ApplicationRecord
	belongs_to :category
	has_many :items, dependent: :destroy

	validates :name, presence: true
	validates :category_id, presence: true

	# Donne le total des notes pour cette series, au travers des likes de chaque item qu'elle contient
	def likes_count
		total = 0
		self.items.collect { |i| total += i.likes_count } 
		return total
	end

	# Renvoie une liste de série qui contiennent le mot clé donné
	def self.search(keyword, category_id)
		if keyword
			if category_id
				where(category_id: category_id).where('name LIKE ?', "%#{keyword}%")
			else
		  		where('name LIKE ?', "%#{keyword}%")
		  	end
		else
		  scoped
		end
	end

	# Renvoie les elements d'une série triés par numéro puis par nom
	def sorted_items
		self.items.includes(:users).sort_by{ |a| a.numero.to_i }
	end

end
