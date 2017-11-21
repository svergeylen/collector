class Comment < ApplicationRecord
  	belongs_to :post
  	belongs_to :user

  	validates :message, presence: true
  	acts_as_votable # Les users peuvent liker des commentaires

	before_validation :check_user_and_post_exists
	after_save :touch_post


	private

	# Renvoie true si l'utilisateur et le post existe. Le commentaire est alors valide.
	def check_user_and_post_exists
		return ( User.exists?(self.user_id) and Post.exists?(self.post_id) )
	end

	# Lorsqu'un commentaire est created ou updated, on met à jour la date de dernier commentaire dans le post
	def touch_post
		self.post.touch
	end

end
