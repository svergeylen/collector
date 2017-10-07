class Author < ApplicationRecord
	has_many :itemauthors, dependent: :delete_all
	has_many :items, through: :itemauthors

	validates :name, presence: true
end
