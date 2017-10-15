class Category < ApplicationRecord
	has_many :series, dependent: :destroy
	has_many :items, through: :series

	validates :name, presence: true, length: { minimum: 2 }

end
