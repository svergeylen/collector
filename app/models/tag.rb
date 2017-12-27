class Tag < ApplicationRecord
	has_many :ownertags_as_tag,   dependent: :destroy, class_name: "Ownertag"
	has_many :ownertags_as_owner, dependent: :destroy, class_name: "Ownertag", as: :owner
	has_many :items,              through: :ownertags_as_tag, source: :owner, source_type: 'Item'
	has_many :parent_tags,        through: :ownertags_as_tag, source: :owner, source_type: 'Tag'
	has_many :tags,               through: :ownertags_as_owner

	validates :name, presence: true, uniqueness: true

	accepts_nested_attributes_for :ownertags_as_owner
	accepts_nested_attributes_for :ownertags_as_tag
	
end
