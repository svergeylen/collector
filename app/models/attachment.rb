require 'exifr/jpeg'

class Attachment < ApplicationRecord

	belongs_to :element, polymorphic: true

	has_attached_file :image, 
		path: ":rails_root/uploaded_files/:id/:style.:extension",
        url: "attachment/:id/:style.:extension",
        styles: { :big => "1000x1000", :medium => "300x300>", :thumb => "100x100>" },
        source_file_options: { all: '-auto-orient' } # Auto-orient aussi de l'original 

	validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
	validates :user_id, presence: true
	serialize :exif

	after_image_post_process :load_exif 

private 

	def load_exif 
		if image.instance.image_content_type == "image/jpg" or image.instance.image_content_type == "image/jpeg"
		    exif = EXIFR::JPEG.new(image.queued_for_write[:original].path) 
			if exif.nil? or not exif.exif? 
				logger.debug "Pas de données EXIF"
			else			
				self.created_at = exif.date_time
				data = exif.to_hash.extract!(:width, :height, :make, :model, :date_time, :exposure_time, :f_number,
					:exposure_program, :iso_speed_ratings, :software)
				if exif.gps.present?
					data[:latitude] = exif.gps.latitude
					data[:longitude] = exif.gps.longitude
				end
				self.exif = data
			end
		else
			logger.debug "L'image n'est pas un JPG. Pas de données EXIF."
		end
	end

end