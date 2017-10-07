namespace :db do
  desc "Conversion des BD depuis l'ancien site BD vers le site Collector"
  task load_sitebd: :environment do
  	puts "Script pour la Conversion des BD depuis l'ancien site BD vers le site Collector <3"
  	
    userL = User.where(name: "Luc").first
    userS = User.where(name: "Stéphane").first
    userV = User.where(name: "Vincent").first
    category_id = Category.where(name: "Bandes dessinées").first.id

  	puts "Suppression de tous les éléments"
  	Series.destroy_all
  	Author.delete_all


    puts "Import en cours"
  	# Séries
  	Serie.all.each do |s|
  		STDOUT.flush
      print "."

  		new_series = Series.create!(name: s.nom, category_id: category_id, letter: s.lettre)

  		# BDs
  		Bd.where(sid: s.sid).each do |bd|
	  		
        begin

  	  		creation_date = Time.at(bd.datedajout)
          bd.titre = "unknown title" if bd.titre.blank?
  	  		new_item = Item.create!(name: bd.titre, numero: bd.numero, series_id: new_series.id, created_at: creation_date)
  	  		
  	  		# Auteurs
  	  		new_auteurs = bd.auteurs.map{ |a| a.nom }.join(", ")
  	  		new_item.authors_list=new_auteurs

          # Possession
          # Luc uid = 1 
          if bd.is_owned_by(1)
            new_item.itemusers.create!(user_id: userL.id, quantity: 1)
          end
          # Stéphane uid = 2
          if bd.is_owned_by(2)
            new_item.itemusers.create!(user_id: userS.id, quantity: 1)
          end
          # Vincent uid =  9 
          if bd.is_owned_by(9)
            new_item.itemusers.create!(user_id: userV.id, quantity: 1)
          end

  	  		# puts "   "+bd.numero.to_s+") "+bd.titre+" ("+new_auteurs+") ajouté le "+creation_date.to_s

        rescue ActiveRecord::RecordInvalid => invalid
          puts "ERROR : " + invalid.record.errors.inspect
        end

	  	end
  	end
    puts "Fini !"

  end
end
