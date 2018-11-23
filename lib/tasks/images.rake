namespace :images do
  desc "Gestion des images"

  task re_process: :environment do 
  	Attachment.all.each { |p| p.image.reprocess! if File.exist?(p.image.path) }
  end

  task re_exif: :environment do
	require 'fileutils'
	Attachment.all.each do |a|
		if a.exif.blank?
			path = a.image.path
			if File.exist?(path)
				puts "Attachment id="+a.id.to_s+" : Traite les données EXIF"
				puts path	
				if path[-3..-1] == "jpg"
					exif = EXIFR::JPEG.new(path) 
					a.created_at = exif.date_time
					data = exif.to_hash.extract!(:width, :height, :make, :model, :date_time, :exposure_time, :f_number,
						:exposure_program, :iso_speed_ratings, :software)
					if exif.gps.present?
						data[:latitude] = exif.gps.latitude
						data[:longitude] = exif.gps.longitude
					end
					a.exif = data
					a.save
				end
			end
		end

	end
	puts "Finiii :-)"
  end

end
