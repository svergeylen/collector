class Attachment < ApplicationRecord
	belongs_to :element, polymorphic: true

	# attr_accessible :image
	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }

	validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
	validates :user_id, presence: true

end
