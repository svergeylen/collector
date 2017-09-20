class Series < ApplicationRecord
	belongs_to :category
	has_many :items

	validates :name, presence: true, length: { minimum: 2 }
	validates :category_id, presence: true

	# Donne le total des notes pour cette series, au travers des likes de chaque item qu'elle contient
	def likes_count
		total = 0
		self.items.collect { |i| total += i.likes_count } 
		return total
	end

	# Renvoie une liste de série qui contiennent le mot clé donné
	def self.search(keyword)
		if keyword
		  where('name LIKE ?', "%#{keyword}%")
		else
		  scoped
		end
	end



end
