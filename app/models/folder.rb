class Folder < ApplicationRecord
	has_ancestry
	
	has_many :items
	
	
	# Renvoie une liste de folders qui contiennent le mot clé donné
	def self.search(keyword)
		keyword = keyword.downcase
		if keyword.present?
			where('name LIKE ?', "%#{keyword}%").order(name: :asc)
		else
		 	all
		end
	end
	
end
