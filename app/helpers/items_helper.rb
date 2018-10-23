module ItemsHelper

	# Renvoie la liste des avatar des users qui possèdent cet item et la quantité
	def render_users(item)
		ret = ""
		item.itemusers.each do |iu|
			if (iu.quantity > 0)
				ret += link_to iu.user do
					profile_picture(iu.user, iu.quantity )
				end
			end
		end
		return ret.html_safe
	end

end
