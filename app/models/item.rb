class Item < ApplicationRecord
	belongs_to :series

	validates :name, presence: true, length: { minimum: 2 }
	validates :series_id, presence: true

	def self.search(keyword)
		if keyword
		  where('name LIKE ?', "%#{keyword}%")
		else
		  scoped
		end
	end

end
