class Folder < ApplicationRecord
	has_ancestry
	
	has_many :items
	
	before_destroy :reallocate_items
	
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
	
	private
	def reallocate_items
		if self.is_root?
			logger.debug "ERROR : Items cannot be reallocated without any root folder"
		else
			self.items.update_all(folder_id: self.root.id)
		end
	end
end
