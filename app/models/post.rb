class Post < ApplicationRecord
	belongs_to :user
	has_many :comments, dependent: :destroy

	has_many :attachments, as: :element, :dependent => :destroy
	accepts_nested_attributes_for :attachments

	acts_as_votable # les users peuvent liker des posts

	before_validation :check_user_exists

	# Supprime toute mémorisation d'un lien ou d'un identifiant youtube dans le post
	def remove_preview
		self.preview_url = nil
		self.preview_title = nil
		self.preview_description = nil
		self.preview_image_url = nil
		self.youtube_id = nil
		self.save
	end

	private

	def check_user_exists
		return User.exists?(self.user_id)
	end
end
