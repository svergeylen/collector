class Folder < ApplicationRecord
	has_ancestry orphan_strategy: :adopt
	
	has_many :items
	
	before_validation :add_letter, :save_parent
	before_destroy :reallocate_items

	attr_writer :parent_name		# version string du folder parent

	# Donne le nom du parent
	def parent_name
		@parent_name || (parent.present? ? parent.name : "")
	end

	# Before_save : Sauvegarde le nom du folder donné en string
	def save_parent
		logger.debug "-------- Folder : before_save : save_parent ---------"
		if @parent_name
			# Si le texte renvoyé est vide, cela devient un noeud racine
			if @parent_name == ""
				self.parent = nil
			else
				# On n'associe le folder à son parent QUE si le parent existe. Sinon, on ne modifie pas le parent du tout (ignore)
				folder = Folder.find_by(name: @parent_name)
				self.parent = folder if folder.present?
			end
		end
	end
	
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
