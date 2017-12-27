class Comment < ApplicationRecord
  	belongs_to :post, touch: true
  	belongs_to :user

  	validates :message, presence: true
  	acts_as_votable # Les users peuvent liker des commentaires

	before_validation :check_user_and_post_exists


	private

	# Renvoie true si l'utilisateur et le post existe. Le commentaire est alors valide.
	def check_user_and_post_exists
		return ( User.exists?(self.user_id) and Post.exists?(self.post_id) )
	end

end
