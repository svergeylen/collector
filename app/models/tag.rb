class Tag < ApplicationRecord
	has_and_belongs_to_many :items

	validates :name, presence: true

	# Renvoie les tags reliés au travers des items
	def related
		related_ids = self.items.collect { |item| item.tag_ids }.flatten.uniq
	    related_ids = related_ids - [self.id]
	    if related_ids
	    	return Tag.find(related_ids).sort_by{ |t| t.name}
	  	else
	  		return nil
	  	end
	end
end
