class Category < ApplicationRecord
	has_many :series

	validates :name, presence: true, length: { minimum: 2 }

end
