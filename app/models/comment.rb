class Comment < ApplicationRecord
  	belongs_to :post, touch: true
  	belongs_to :user

  	validates :message, presence: true
  	acts_as_votable # Les users peuvent liker des commentaires

	before_validation :check_user_and_post_exists


	# Renvoie une liste de comments qui contiennent le mot clé donné
	def self.search(keyword)
		keyword = keyword.downcase
		if keyword.present?
			comments = where('message LIKE ?', "%#{keyword}%").order(created_at: :desc)
		else
		 	comments = all
		end

		# /!| Duplicate de POST.search 
		# Suppression de tous les champs HTML et liens pour éviter des faux positifs dans la recherche
		ret = []
		comments.each do |comment| 
			msg = ActionController::Base.helpers.sanitize(comment.message, tags: %w(a), attributes: %w(href))
			comment.message = msg
			if msg.downcase.include?(keyword)
				ret << comment 
			end
		end
		return ret

	end

	private

	# Renvoie true si l'utilisateur et le post existe. Le commentaire est alors valide.
	def check_user_and_post_exists
		return ( User.exists?(self.user_id) and Post.exists?(self.post_id) )
	end

end
