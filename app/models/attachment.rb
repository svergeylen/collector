class Attachment < ApplicationRecord
	belongs_to :element, polymorphic: true

	has_attached_file :image, 
		path: ":rails_root/uploaded_files/:id/:style.:extension",
        url: "attachment/:id/:style.:extension",
        styles: { :medium => "300x300>", :thumb => "100x100>" },
        convert_options: { :all => '-auto-orient' }

	validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
	validates :user_id, presence: true
end
