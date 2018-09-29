module ApplicationHelper

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

		return mydate.strftime("%d") + " " + mois.capitalize + " " + mydate.strftime("%y, %Hh%M")
	end

	def short_date(mydate) 
		if mydate.strftime("%Y") == Time.now.strftime("%Y")
			return mydate.strftime("%d/%m")
		else
			return mydate.strftime("%d/%m/%y")
		end
	end

end
