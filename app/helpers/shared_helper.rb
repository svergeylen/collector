module SharedHelper

	def latest_block_title(category_name) 
		if (category_name.nil?) 
			return "Derniers ajouts"
		else 
			return raw "Derniers ajouts"+" <small>("+ category_name + ")</small>"
		end		
	end

end



