class Tag < ApplicationRecord
	has_many :ownertags_as_tag,   dependent: :destroy, class_name: "Ownertag"
	has_many :ownertags_as_owner, dependent: :destroy, class_name: "Ownertag", as: :owner
	has_many :items,              through: :ownertags_as_tag, source: :owner, source_type: 'Item'
	has_many :parent_tags,        through: :ownertags_as_tag, source: :owner, source_type: 'Tag'
	has_many :tags,               through: :ownertags_as_owner

	validates :name, presence: true

	accepts_nested_attributes_for :ownertags_as_owner
	accepts_nested_attributes_for :ownertags_as_tag

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
