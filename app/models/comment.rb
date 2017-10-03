class Comment < ApplicationRecord
  	belongs_to :post
  	belongs_to :user

  	validates :message, presence: true
  	acts_as_votable # Les users peuvent liker des commentaires

	before_validation :check_user_and_post_exists



	private

	def check_user_and_post_exists
		return ( User.exists?(self.user_id) and Post.exists?(self.post_id) )
	end

end
