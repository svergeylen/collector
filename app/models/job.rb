class Job < ApplicationRecord
	belongs_to :user
	belongs_to :element, polymorphic: true


end
