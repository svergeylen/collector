class Tag < ApplicationRecord
	
	# Un tag est relié à des tags et/ou des items via la table Ownertag
	has_many :ownertags_as_tag,   dependent: :destroy, class_name: "Ownertag"
	# Un tag possède de multiples items (filtrage de Ownertag sur le type "Item")
	has_many :items,              through: :ownertags_as_tag, source: :owner, source_type: 'Item'

	accepts_nested_attributes_for :ownertags_as_tag, allow_destroy: true
	
	validates :name, presence: true, uniqueness: {:case_sensitive => false}
	
	before_save :uppercaseletter


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

private
	
	def uppercaseletter
		self.letter = self.name[0] if self.letter.nil?
		self.letter = self.letter.upcase
	end

end
