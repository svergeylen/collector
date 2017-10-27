class Job < ApplicationRecord
	serialize :memory

	belongs_to :user
	belongs_to :element, polymorphic: true


end
