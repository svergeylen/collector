namespace :db do
  desc "Conversion des données site Collector"



  task convert_bd: :environment do
	livres              = Folder.create(name: "Livres", root_folder: true, default_view: "none")
		bd          	= Folder.create(name: "Bandes dessinées", default_view: "none")
			auteurs		= Folder.create(name: "Auteurs", default_view: "none")
			themes	  	= Folder.create(name: "Thèmes", default_view: "none")
			  sf = Folder.create(name: "Science-Fiction", default_view: "list")
			  hs = Folder.create(name: "Histoire", default_view: "list")
			  ph = Folder.create(name: "Philosophie", default_view: "list")
			  so = Folder.create(name: "Space opera", default_view: "list")
			  th = Folder.create(name: "Thriller", default_view: "list")
			  themes.folders << [sf, hs, ph, so, th]
			series		= Folder.create(name: "Séries", default_view: "none")
	livres.folders << bd
	bd.folders << [auteurs, themes, series]

	generic("Bandes dessinées", 1, series.id)

	# Association de tous les folders existants (ex-tags auteurs) dans le nouveau folder "Auteurs"
	Folder.where(category_id: 1).each do |folder|
		auteurs.folders << folder
	end
  end


  task convert_romans: :environment do
	id = Folder.where(name: "Livres").first.id
	generic("Romans", 2, id)
  end

  task convert_bonsais: :environment do
	generic("Bonsais", 4, nil)
  end

  task convert_livres: :environment do
	id = Folder.where(name: "Livres").first.id
	generic("Didactiques", 6, id)
  end

  task convert_ludo: :environment do
	generic("Ludothèque", 8, nil)
  end

 task convert_voyage: :environment do
	id = Folder.where(name: "Livres").first.id
	generic("Voyage", 10, id)
  end

 task convert_modelisme: :environment do
	generic("Modélisme", 12, nil)
  end
	

private

	def generic(folder_name, category_id, parent_folder_id)
		puts "Generic Convert for category_id="+category_id.to_s+" to folder name='"+folder_name+"'"

		if Folder.where(name: folder_name).exists?
			parent_folder		= Folder.where(name: folder_name).first
		else
			if 	parent_folder_id.present?
				parent_folder		= Folder.create(name: folder_name, default_view: "none") 
				parent_folder.parent_folders << Folder.find(parent_folder_id.to_i)
			else
				parent_folder		= Folder.create(name: folder_name, default_view: "none", root_folder: true) 
			end
		end

		Series.where(category_id: category_id).each do |serie|
			puts "  - "+serie.name+" ("+serie.items.count.to_s+" items)"
			if Folder.where(name: serie.name).exists?
				current_folder  = Folder.where(name: serie.name).first
			else
				current_folder = Folder.create(name: serie.name, letter: serie.letter, default_view: "list" )
			end
			parent_folder.folders << current_folder
			serie.items.each do |item|
				item.folders << [current_folder, parent_folder]
			end
			
		end
		puts "Done :-)"
	end

end
