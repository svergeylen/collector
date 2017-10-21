class User < ApplicationRecord
  	# Include default devise modules. Others available are:
  	# :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  	has_many :itemusers
	has_many :items, through: :itemusers

	# Blog
	has_many :posts, dependent: :destroy
	has_many :comments, through: :posts

	acts_as_voter # les users peuvent mettre des likes sur les posts et les items

	has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>", tiny: "30x30>" }, default_url: "default-profile/:style.png"
	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

	def last_added_items(months_quantity)
		self.items.where(["quantity > ?", 0]).where(created_at: (Date.current-months_quantity.months)..Date.current).order(created_at: :desc)
	end

end
