class Folder < ApplicationRecord
	
	# Un folder peut avoir plusieurs parents (au-dessus de lui) ou zéro (orphan)
	has_many :ownerfolders_as_folder,   dependent: :destroy, class_name: "Ownerfolder"
	has_many :parent_folders,        	through: :ownerfolders_as_folder, source: :owner, source_type: 'Folder'

	# Un folder peut contenir plusieurs sub-folders (hiérarchie de dossiers)
	has_many :ownerfolders_as_owner, 	dependent: :destroy, class_name: "Ownerfolder", as: :owner
	has_many :folders,               	through: :ownerfolders_as_owner

	# Un folder contient des items (bd, livres, jeux, bonsais, ...)
	has_many :items,              	 	through: :ownerfolders_as_folder, source: :owner, source_type: 'Item'

	validates :name, presence: true, uniqueness: true

	accepts_nested_attributes_for :ownerfolders_as_owner, allow_destroy: true
	accepts_nested_attributes_for :ownerfolders_as_folder, allow_destroy: true
	
	before_destroy :check_is_fixture

	# Renvoie la liste des folders enfants de ce folder, classés dans l'ordre
	def children
		return self.folders.order(name: :asc)
	end

	# Renvoie la liste des items contenues dans ce folder
	def sorted_items
		self.items.includes(:users).sort_by{ |a| [a.number.to_f, a.name] }
	end

	# Remplace tous les folders parents par ceux donnés. 
	# Place root_folder=true si aucun parent n'est donné
	def update_parent_folders(new_folder_ids)
		# On retire l'élément vide envoyé d'office par Rails pour les champ select multiple
		new_folder_ids = new_folder_ids - [""]

		# Si le folder ne possède plus de parent, on assigne root_folder et inversément
		self.root_folder = new_folder_ids.empty? ? true : false

		# On assigne les ids uniquement. Rails s'occupe de supprimer les relations qui ne sont plus dans la sélection
		self.parent_folder_ids = new_folder_ids.collect { |x| x.to_i }

		self.save # ?
	end

	# Renvoie une liste de folders qui contiennent le mot clé donné
	def self.search(keyword)
		if keyword.present?
			where('name LIKE ?', "%#{keyword}%").order(name: :asc)
		else
		 	all
		end
	end

	private

	# Empeche la suppression de Folders nécessaires au bon fonctionnement de l'application Rails (self.fixture = true)
	def check_is_fixture
		throw(:abort) if self.fixture
	end

end
