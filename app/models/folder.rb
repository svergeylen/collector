class Folder < ApplicationRecord
	has_ancestry
	
	has_many :items
	
	# renvoie les 6 derniers items modifié de ce folder OU des folders enfants
	def last_modified
		Item.belongs_to_folder(self).order(updated_at: :desc).limit(6)
	end
	
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
