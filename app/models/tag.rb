class Tag < ApplicationRecord
	
	# Un tag est relié à des tags et/ou des items via la table Ownertag
	has_many :ownertags_as_tag,   dependent: :destroy, class_name: "Ownertag"
	# Un tag possède de multiples parents (filtrage de Ownertag sur le type "Tag")
	has_many :parent_tags,        through: :ownertags_as_tag, source: :owner, source_type: 'Tag'
	# Un tag possède de multiples items (filtrage de Ownertag sur le type "Item")
	has_many :items,              through: :ownertags_as_tag, source: :owner, source_type: 'Item'

	# Un tag peut contenir plusieurs enfants 
	has_many :ownertags_as_owner, dependent: :destroy, class_name: "Ownertag", as: :owner
	has_many :tags,               through: :ownertags_as_owner

	# Un tag peut être ajouté comme favoris par des utilisateurs
	has_many :favourites
	has_many :users, through: :favourites

	accepts_nested_attributes_for :ownertags_as_owner, allow_destroy: true
	accepts_nested_attributes_for :ownertags_as_tag, allow_destroy: true
	
	validates :name, presence: true, uniqueness: {:case_sensitive => false}
	
	before_save :uppercaseletter

# --------------------- TAGS PARENTS ---------------------------------------------------------------------------

	attr_writer :parent_tag_names 	# liste de tags parents
	before_save :save_parent_tags
	
	# Donne les tags parents, au format string séparé par une virgule
	def parent_tag_names
		@parent_tag_names || parent_tags.pluck(:name).join(", ")
	end

	# Before_save : Sauvegarde les tags parents donnés dans une liste de string séparée par des virgule en objets Tag
	def save_parent_tags
		if @parent_tag_names
			parent_tags = []
			@parent_tag_names.split(",").each do |name| 
				name = name.strip
				next if name == ""
				next if name.downcase == self.name.downcase # ignore une éventuelle récursion
				parent_tags << Tag.where(name: name).first_or_create!
			end
			# Mémorisation de la caractéristique root_tag (cache)
			self.root_tag = @parent_tag_names.empty? ? true : false
			self.parent_tags = parent_tags
		end
	end

# ------------------------- TAGS ENFANTS -----------------------------------------------------------------------

	# Renvoie la liste des tags enfants de ce tag, classés dans l'ordre alphabétique
	def children()
		return self.tags.order(name: :asc)
	end

	# Crée des tags subordonnés au tag self, sur base de l'array tag_names donné (array de string)
	# Renvoie un array de tags reprennant tous les tags correspondants à tag_names
	def create_children(tag_names)
		created_tags = []
		if tag_names.present?
			tag_names.each do |tag_name|
				tag_name = tag_name.strip
				next if tag_name == ""
	  			# Recherche d'un tag existant sur base du nom string donné (ou création)
	  			tag = Tag.find_or_create_by(name: tag_name)
	  			# Association des tags créés comme enfants de self, sans faire de doublon
				unless self.tags.include?(tag)
					self.tags << tag 
				end
				created_tags << tag
	  		end
	  	end
  		return created_tags
	end

	# Renvoi tous les tags pour le champ recherche de tags
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

private
	
	def uppercaseletter
		self.letter = self.name[0] if self.letter.nil?
		self.letter = self.letter.upcase
	end

end
