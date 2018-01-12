class Tag < ApplicationRecord
	has_many :ownertags_as_tag,   dependent: :destroy, class_name: "Ownertag"
	has_many :ownertags_as_owner, dependent: :destroy, class_name: "Ownertag", as: :owner
	has_many :items,              through: :ownertags_as_tag, source: :owner, source_type: 'Item'
	has_many :parent_tags,        through: :ownertags_as_tag, source: :owner, source_type: 'Tag'
	has_many :tags,               through: :ownertags_as_owner

	validates :name, presence: true, uniqueness: true

	accepts_nested_attributes_for :ownertags_as_owner, allow_destroy: true
	accepts_nested_attributes_for :ownertags_as_tag, allow_destroy: true
	
	before_destroy :check_is_fixture

	# Renvoie la liste des tags enfants de ce tag, classés dans l'ordre
	def children
		return self.tags.order(name: :asc)
	end

	# Renvoie la liste des items contenues dans ce tag
	def sorted_items
		self.items.includes(:users).sort_by{ |a| [a.number.to_f, a.name] }
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

	private

	# Empeche la suppression de Tags nécessaires au bon fonctionnement de l'application Rails (self.fixture = true)
	def check_is_fixture
		throw(:abort) if self.fixture
	end

end
