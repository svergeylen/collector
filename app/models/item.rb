class Item < ApplicationRecord
	belongs_to :series

	validates :name, presence: true, length: { minimum: 2 }
	validates :series_id, presence: true

end
