module ApplicationHelper

	# Affiche le nom de la dernière catégorie choisie (current)
	def link_to_current_category
		if (session[:category]) 
			begin
				cat = Category.find(session[:category])
			rescue ActiveRecord::RecordNotFound => e
				return ""
			end
			return link_to(cat.name, category_path(cat), class: "white" )
		else
			return ""
		end
	end

	# Renvoie une date courte en français
	def long_date(mydate) 
		
		case mydate.strftime("%m")
			when "01"
				mois = "janvier"
			when "02"
				mois = "février"
			when "03"
				mois = "mars"
			when "04"
				mois = "avril"
			when "05"
				mois = "mai"
			when "06"
				mois = "juin"
			when "07"
				mois = "juillet"
			when "08"
				mois = "août"
			when "09"
				mois = "septembre"
			when "10"
				mois = "octobre"
			when "11"
				mois = "novembre"
			when "12"
				mois = "décembre"
			else
				mois = "inconnu"
			end

		return mydate.strftime("%d") + " " + mois.capitalize + " " + mydate.strftime("%y %Hh%M")
	end

	def short_date(mydate) 
		return mydate.strftime("%d/%m")
	end

end
