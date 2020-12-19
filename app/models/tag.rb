class Tag < ApplicationRecord
	has_and_belongs_to_many :items
	
	validates :name, presence: true, uniqueness: {:case_sensitive => false}


	# Renvoie tous les tags pour le champ recherche de tags
	def self.searchable_tags
		return Tag.order(name: :asc).select(:id, :name).map{ |el| {value: el.name, label: el.name, id: el.id.to_s} }
	end


	# Renvoie une liste de tags qui contiennent le mot clé donné
	def self.search(keyword)
		keyword = keyword.downcase
		if keyword.present?
			where('name LIKE ?', "%#{keyword}%").order(name: :asc)
		else
		 	all
		end
	end


end
