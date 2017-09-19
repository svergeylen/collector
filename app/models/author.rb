class Author < ApplicationRecord
	has_many :itemauthors
	has_many :items, through: :itemauthors

end
