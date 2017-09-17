class Series < ApplicationRecord
	belongs_to :category
	has_many :items

	validates :name, presence: true, length: { minimum: 2 }
	validates :category_id, presence: true

end
