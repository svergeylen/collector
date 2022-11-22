namespace :db do
	desc "Conversion des données site Collector"


	# Extraction des Bonsais en fichiers, dossiers et avec images orginale
	task exportbonsais: :environment do
	require 'fileutils'
		puts "Export des Bonsais"	
		prefix = 'tmp/exportbonsais/'
		FileUtils.mkdir_p prefix
		Folder.find_by(name: "Bonsais").children.order(name: :asc).each do |folder|
				puts "  "+folder.name+" => "+			folder.items.count.to_s+" bonsais"
				FileUtils.mkdir_p prefix + folder.name
				folder.items.order(number: :asc).each do |bonsai|
					puts "    - "+bonsai.name + ", " + bonsai.notes.count.to_s + " notes, "+ bonsai.attachments.count.to_s + " attachements"
					path = prefix + folder.name + "/" + bonsai.name
					FileUtils.mkdir_p path
					
					File.open(path+ "/" + bonsai.name + ".md", "w") do |f| 
						puts "      "
						f.write("# " + bonsai.name +"\n")
						f.write("Ajouté le " + bonsai.created_at.strftime("%d/%m/%Y") + "\n\n")
						f.write(bonsai.description.to_s + "\n\n")

						
						bonsai.notes.order(created_at: :asc).each do |note|
							puts "     "+note.message.to_s
							f.write(" - "+note.created_at.strftime("%d/%m/%Y") +" : "+note.classification.to_s+ " - "+note.message.to_s+"\n")
						end
						
						bonsai.attachments.each do |a|
							name = a.image.instance.image_file_name.to_s
							FileUtils.cp(a.image.path, path+"/"+name)
						end
						
					end
					
				end
			
			end
		puts "Fin"
	end
	

	# Extraction des BD en fichiers
	task exportBD: :environment do
	require 'fileutils'
		puts "Export des BD"	
		FileUtils.mkdir_p 'tmp/exportBD'
		File.open("tmp/exportBD/export.html", "w") do |f| 
			f.write("<h1>Export des BD</h1>")
			Folder.find_by(name: "BD").children.order(name: :asc).each do |folder|
				puts " - "+folder.name+". "+			folder.items.count.to_s+" items"
				f.write("<h2>"+folder.name + "</h2>\n")
				f.write("<div class='list'>")
				folder.items.order(number: :asc).each do |item|
					puts "  - "+item.name
					f.write("<p>"+item.friendly_number+"#tab#"+item.name+"#tab#"+item.tag_names+"</p>")
				end
			f.write("</div>")				
			end
		end
		puts "Fin"
	end
	
	
	# Extraction des bonsais en fichiers
	task export: :environment do
	require 'fileutils'
		puts "Exportdes bonsais"	
		FileUtils.mkdir_p 'tmp/export'
		Folder.find_by(name: "Bonsais").children.each do |folder|
			puts " - "+folder.name+". "+			folder.items.count.to_s+" items"
			folder.items.each do |item|
				puts "  - "+item.name
				FileUtils.mkdir_p 'tmp/export/' + folder.name.gsub(/[^0-9A-z.\-]/, ' ')
				filename = "tmp/export/" + folder.name.gsub(/[^0-9A-z.\-]/, ' ') + "/" + item.name.gsub(/[^0-9A-z.\-]/, ' ')+".txt"
				
				File.open(filename, "w") do |f| 
					f.write(folder.name + " : "+ item.name+"\n")
					f.write("  créé le "+item.created_at.strftime("%d %B %Y").to_s+"\n\n")
					f.write(item.description.to_s+"\n\n") if item.description.present?
									
					item.notes.order(created_at: :desc	).each do |note|
						f.write(note.created_at.strftime("%d %B %Y").to_s+"\n") 
						f.write(note.classification.to_s+"\n") if note.classification.present?
						f.write(note.message.to_s+"\n\n")  if note.message.present?
					end
				end	
			end
		end
		puts "Fin"
	end
	

	# Crée les folders 
	task create_folders_items: :environment do
		puts "Création des folders"	
		# Root folder à créer
		root_folders  = ["Bandes dessinées", "Bonsais", "Livres", "Jeux de société", "Modélisme", "Pièces"]
		# nom du tag qui contient l'information principale de "série", pour chaque root_folders
		serie_parents = ["Séries",           "Espèces", "Thèmes", "Par genre",       "Modélisme", "Pièces par pays"]
		
		# Je commence par créer les root_folder pour que les ID soient de 1 à 7, pour le plaisir
		root_folders.each do |root_folder_name|
			parent = Folder.find_or_create_by(name: root_folder_name)
		end
		
		# Je crée les sous-dossiers (=série) et place chaque item dedans. Un fodler/série par item
		root_folders.each_with_index do |root_folder_name, index|
			puts "------- Debut --------- "+root_folder_name
			parent = Folder.find_or_create_by(name: root_folder_name)
			Tag.find_by_name(root_folder_name).items.each do |item|		
				serie_parent = serie_parents[index]
				puts "   - "+item.id.to_s+": "+item.name+" --> "+serie_parent
				tag = item.tag_serie_by(serie_parent)
				serie_name = (tag.present? ? tag.name : "")
				# Recherche le dossier s'il existe (série existante) ou création
				folder = Folder.find_or_create_by(name: serie_name)
				folder.parent = parent
				folder.default_view = tag.default_view if tag.present?
				folder.letter = tag.letter if tag.present?
				folder.save
				# place l'item dans ce dossier
				item.folder = folder
				item.save
			end
			puts "------- Fin --------- "+root_folder_name
		end 
		puts "--- Conclusions ---"
		puts "Folder sans parent : "
		puts Folder.roots.pluck(:name).join(", ")
		puts "Item sans folder : "
		puts Item.where(folder_id: :nil).pluck(:name).join(", ")
		puts "Fin de fin"
	end
	
	# Livres et films à la main... 
	task update_films: :environment do
		puts "--- début ---"
		film_folder = Folder.find_or_create_by(name: "Films") 
		
		items_ids = Item.where(folder_id: nil).each do |item|
			if item.tags.first.name == "Voie libre"
				item.destroy 
			else
				item.folder = film_folder
				item.save
			end	
		end
		puts "--- fin---"
		
	end
	
	
	# Siplification de tags redondants avec les folders
	task tag_simplify: :environment do
		puts "Simplification des tags"	
		Folder.all.each do |folder|
			tag = Tag.where(name: folder.name).first
			if tag.present?
				puts folder.name+" -- "+tag.name
				tag.destroy
			end
		end
		
		puts "Fin"
	end
	
	
	task convert_bd: :environment do
		bd          = Tag.create(name: "Bandes dessinées", root_tag: true)
		auteurs		= Tag.create(name: "Auteurs", default_view: "list")
		themes	  	= Tag.create(name: "Thèmes", default_view: "list", filter_items: false)
		  sf = Tag.create(name: "Science-Fiction", default_view: "list")
		  hs = Tag.create(name: "Histoire", default_view: "list")
		  ph = Tag.create(name: "Philosophie", default_view: "list")
		  so = Tag.create(name: "Space opera", default_view: "list")
		  th = Tag.create(name: "Thriller", default_view: "list")
		  themes.tags << [sf, hs, ph, so, th]
		series		= Tag.create(name: "Séries", default_view: "list", filter_items: false)
		bd.tags << [auteurs, themes, series]

		generic("Bandes dessinées", 1, series.id)

		# Déplacement de tous les auteurs dans le tag "Auteurs"
		Tag.where(category_id: 1).each do |tag|
			auteurs.tags << tag
		end
	end


	task convert_livres: :environment do
		livre = Tag.create(name: "Livres", root_tag: true)
		id = livre.id
		generic("Livres", 2, id) # Fusion des romans dans livres
		generic("Livres", 6, id) # Fusion des livres techniques dans Livres
		generic("Voyage", 10, id) # On garde un sous-dossier voyage dans Livres
	end

	task convert_bonsais: :environment do
		livre = Tag.create(name: "Bonsais", root_tag: true)
		generic("Bonsais", 4, nil)
	end

	task convert_ludo: :environment do
		generic("Ludothèque", 8, nil)
	end

	task convert_modelisme: :environment do
		generic("Modélisme", 12, nil)
	end

	# Passe certains tag en vue gallerie par défaut ou lieu de vue en liste
	task activate_gallery: :environment do 
		bonsais = Tag.where(name:"Bonsais").first
		bonsais.tags.update_all(default_view: "gallery")
		ludo = Tag.where(name:"Ludothèque").first
		ludo.tags.update_all(default_view: "gallery")
		modelisme = Tag.where(name:"Modélisme").first
		modelisme.tags.update_all(default_view: "gallery")
	end

	task humanize_tags: :environment do
		auteurs_tag = Tag.find_by(name: "Auteurs")
		auteurs_tag.children.each do |tag| 
			new_name = tag.name.humanize
			puts tag.name + " --> " + new_name
			tag.name = new_name
			tag.save
		end
	end

	# Corrige l'item_type pour les items qui possède le tag BD
	task update_type_bd: :environment do
		bd = Tag.find_by(name: "Bandes dessinées")
		item_ids = Item.having_tags( [ bd.id ] ).map(&:id)
		puts item_ids.inspect
		Item.where(id: item_ids).update_all(item_type: "bd" )
	end

	# Corrige l'item_type pour les items qui possède le tag "Bonsai"
	task update_type_plante: :environment do
		bonsais = Tag.find_by(name: "Bonsais")
		item_ids = Item.having_tags( [ bonsais.id ] ).map(&:id)
		puts item_ids.inspect
		Item.where(id: item_ids).update_all(item_type: "plante" )
	end

	# Corrige l'item_type pour les items qui possède le tag "Pièces"
	task update_type_pieces: :environment do
		pieces = Tag.find_by(name: "Pièces")
		item_ids = Item.having_tags( [ pieces.id ] ).map(&:id)
		puts item_ids.inspect
		Item.where(id: item_ids).update_all(item_type: "piece" )
	end

	# Corrige l'item_type pour les items qui possède le tag "Films"
	task update_type_films: :environment do
		films = Tag.find_by(name: "Films")
		item_ids = Item.having_tags( [ films.id ] ).map(&:id)
		puts item_ids.inspect
		Item.where(id: item_ids).update_all(item_type: "film" )
	end

	# Recherche les items qui ont des tags en double, supprime tous les tags et réassocie les tag_ids uniques
	task remove_duplicate_tags_in_items: :environment do 
		Item.all.each do |item|
			tag_ids = item.tag_ids
			uniq_tag_ids = tag_ids.uniq
			if tag_ids.size != uniq_tag_ids.size
				puts "Correction de doublons pour item_id="+item.id.to_s+" : "+item.tags.pluck(:name).inspect
				item.tags.clear
				item.tag_ids = uniq_tag_ids
			end
		end
	end

	# Donne une lettre de classement (letter) aux tags qui n'en n'ont pas encore
	task add_letter_to_tag: :environment do 
		Tag.all.each do |tag|
			if tag.letter.nil? or tag.letter.empty?
				tag.letter = tag.name[0].upcase
				tag.save
				puts "Correction de lettre pour le tag="+tag.name.to_s+" : "+tag.letter.to_s
			end
		end
	end


private

	def generic(tag_name, category_id, parent_tag_id)
		puts "Generic Convert for category_id="+category_id.to_s+" to tag name='"+tag_name+"'"

		# Recherche du tag parent (souvent un root_tag)
		if Tag.where(name: tag_name).exists?
			parent_tag		= Tag.where(name: tag_name).first
		else
			if 	parent_tag_id.present?
				parent_tag		= Tag.create(name: tag_name, default_view: "list") 
				parent_tag.parent_tags << Tag.find(parent_tag_id.to_i)
			else
				parent_tag		= Tag.create(name: tag_name, default_view: "list", root_tag: true) 
			end
		end

		Series.where(category_id: category_id).each do |serie|
			puts "  - "+serie.name+" ("+serie.items.count.to_s+" items)"
			if Tag.where(name: serie.name).exists?
				current_tag  = Tag.where(name: serie.name).first
			else
				current_tag = Tag.create(name: serie.name, letter: serie.letter, default_view: "list" )
			end
			parent_tag.tags << current_tag
			serie.items.each do |item|
				item.tags << [current_tag, parent_tag] # Ex-serie convertie en tag et root_tag
				item.tags << item.old_tags # anciens auteurs de la table items_tags
			end
			
		end
		puts "Done :-)"
	end

end
