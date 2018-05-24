namespace :files do
  desc "Déplacement des atatchements vers dossier protégé"

  task move_uploads: :environment do
	require 'fileutils'
	from_d = Rails.root.to_s+"/public/system/attachments/images/000/000/"
	to_d = Rails.root.to_s+"/uploaded_files/"
	puts "Déplacement des fichiers uploadés..."
	puts "De :   " + from_d
	puts "Vers : " + to_d

	# Liste des dossier à transférer
	Dir.chdir(from_d)
	list = Dir.glob('*').select { |f| File.directory? f }
	
	list.each do |name|
		puts "Déplacement de "+name.to_s
		Dir.mkdir to_d + name if !File.directory?(to_d + name)

		# Recherche du nom de fichier variable
		medium = Dir.glob(File.join(from_d + name+"/medium",  '*.jpg')).select { |file| File.file?(file) }.first
		thumb = Dir.glob(File.join(from_d + name+"/thumb",  '*.jpg')).select { |file| File.file?(file) }.first
		original = Dir.glob(File.join(from_d + name+"/original",  '*.jpg')).select { |file| File.file?(file) }.first

		# Déplacement des fichiers
		FileUtils.mv(medium, to_d+name+"/medium.jpg") if medium
		FileUtils.mv(thumb, to_d+name+"/thumb.jpg") if thumb
		FileUtils.mv(original, to_d+name+"/original.jpg") if original

	end

	puts "Done :-)"
  end

end
