class Post < ApplicationRecord
	belongs_to :user
	has_many :comments, dependent: :destroy

	has_many :attachments, as: :element, :dependent => :destroy
	accepts_nested_attributes_for :attachments

	validates :message, presence: { message: "Le contenu du message ne peut pas être vide" }

	acts_as_votable # les users peuvent liker des posts

	before_validation :check_user_exists


	private

	def check_user_exists
		return User.exists?(self.user_id)
	end
end
