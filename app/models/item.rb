class Item < ApplicationRecord
	belongs_to :series
	has_many :itemauthors
	has_many :authors, through: :itemauthors

	validates :name, presence: true, length: { minimum: 2 }
	validates :series_id, presence: true


	# Récupère la liste des Item asociés à un auteur donné
	def self.written_by(name)
		Author.find_by_name!(name).items
	end

	# Liste les auteurs de l'item
	def authors_list
		authors.map(&:name).join(", ")
	end

	# Associe l'item à un auteur exitant ou créé un nouvel auteur
	def authors_list=(names)
		self.authors = names.split(",").map do |n|
		  Author.where(name: n.strip).first_or_create!
		end
	end

	# Recherche les items contenant le mot clé donné
	def self.search(keyword)
		if keyword
		  where('name LIKE ?', "%#{keyword}%")
		else
		  scoped
		end
	end

end
