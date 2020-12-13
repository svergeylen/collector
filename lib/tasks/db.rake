namespace :db do
	desc "Conversion des données site Collector"


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
