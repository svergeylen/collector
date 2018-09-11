class Tag < ApplicationRecord
	
	# Un tag peut avoir plusieurs parents (au-dessus de lui) ou zéro (orphan)
	has_many :ownertags_as_tag,   dependent: :destroy, class_name: "Ownertag"
	has_many :parent_tags,        	through: :ownertags_as_tag, source: :owner, source_type: 'Tag'

	# Un tag peut contenir plusieurs sub-tags (hiérarchie de tags)
	has_many :ownertags_as_owner, 	dependent: :destroy, class_name: "Ownertag", as: :owner
	has_many :tags,               	through: :ownertags_as_owner

	# Un tag contient des items (bd, livres, jeux, bonsais, ...)
	has_many :items,              	 	through: :ownertags_as_tag, source: :owner, source_type: 'Item'

	validates :name, presence: true, uniqueness: true

	accepts_nested_attributes_for :ownertags_as_owner, allow_destroy: true
	accepts_nested_attributes_for :ownertags_as_tag, allow_destroy: true
	

	# Renvoie la liste des tags enfants de ce tag, classés dans l'ordre
	def children
		return self.tags.order(name: :asc)
	end

	# Renvoie la liste des items contenues dans ce tag
	def sorted_items
		self.items.includes(:users).sort_by{ |a| [a.number.to_f, a.name] }.limit (200)
	end

	# Remplace tous les tags parents par ceux donnés. 
	# Place root_tag=true si aucun parent n'est donné
	def update_parent_tags(new_tag_ids)
		# On retire l'élément vide envoyé d'office par Rails pour les champ select multiple
		new_tag_ids = new_tag_ids - [""]

		# Si le tag ne possède plus de parent, on assigne root_tag et inversément
		self.root_tag = new_tag_ids.empty? ? true : false

		# On assigne les ids uniquement. Rails s'occupe de supprimer les relations qui ne sont plus dans la sélection
		self.parent_tag_ids = new_tag_ids.collect { |x| x.to_i }

		self.save # ?
	end

	# Renvoie une liste de tags qui contiennent le mot clé donné
	def self.search(keyword)
		if keyword.present?
			where('name LIKE ?', "%#{keyword}%").order(name: :asc)
		else
		 	all
		end
	end

end
