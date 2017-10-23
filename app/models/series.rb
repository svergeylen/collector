class Series < ApplicationRecord
	belongs_to :category
	has_many :items, dependent: :destroy

	has_and_belongs_to_many :users

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
		if keyword.present?
			if category_id
				where(category_id: category_id).where('name LIKE ?', "%#{keyword}%")
			else
		  		where('name LIKE ?', "%#{keyword}%")
		  	end
		else
		 	all
		end
	end

	# Renvoie les elements d'une série triés par numéro puis par nom
	def sorted_items
		self.items.includes(:users).sort_by{ |a| a.numero.to_i }
	end

	# Renvoie le numero le plus élevé connu pour cette serie
	def get_max_number
		numbers = self.items.maximum(:number)
		return numbers
	end

	# Renvoie les numéros d'une série que l'utilisateur ne possède pas (encore)
	def missing_numbers(user) 
		maximum = self.get_max_number.to_i
		ideal_list = 1..(maximum+1)  # ON ajoute +1 pour ajouter le numéro suivant à la liste des item manquants
		have_ids = user.itemusers.where(item_id: self.item_ids).where(["quantity > ?", 0]).map(&:item_id)
		missing_ids = ideal_list.to_a - have_ids
		return missing_ids
	end

end
