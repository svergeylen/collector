class Folder < ApplicationRecord
	has_ancestry orphan_strategy: :adopt
	
	has_many :items
	
	before_validation :add_letter
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
	# Add a default letter if empty
	def add_letter
		if self.letter.nil?
			self.letter = self.name[0].upcase
		end
	end
	
	# Move items to the parent folder if existing or move them into a default "orphans" folder.
	def reallocate_items
		if self.is_root?
			f = Folder.find_or_create_by(name: "Orphelins")
			self.items.update_all(folder_id: f.id)
		else
			self.items.update_all(folder_id: self.root.id)
		end
	end
end
