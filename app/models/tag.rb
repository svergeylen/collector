class Tag < ApplicationRecord
	has_many :ownertags_as_tag,   dependent: :destroy, class_name: "Ownertag"
	has_many :ownertags_as_owner, dependent: :destroy, class_name: "Ownertag", as: :owner
	has_many :items,              through: :ownertags_as_tag, source: :owner, source_type: 'Item'
	has_many :parent_tags,        through: :ownertags_as_tag, source: :owner, source_type: 'Tag'
	has_many :tags,               through: :ownertags_as_owner

	validates :name, presence: true, uniqueness: true

	accepts_nested_attributes_for :ownertags_as_owner, allow_destroy: true
	accepts_nested_attributes_for :ownertags_as_tag, allow_destroy: true
	
	def sorted_items
		self.items.includes(:users).limit(300).sort_by{ |a| [a.number.to_f, a.name] }
	end
end
