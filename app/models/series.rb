class Series < ApplicationRecord
	belongs_to :category
	has_many :items

	validates :name, presence: true, length: { minimum: 2 }
	validates :category_id, presence: true



	def self.search(keyword)
		if keyword
		  where('name LIKE ?', "%#{keyword}%")
		else
		  scoped
		end
	end



end
