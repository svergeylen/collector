class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

	has_many :likes, dependent: :destroy
	has_many :liked_items, through: :likes, source: :item
	has_many :posts, dependent: :destroy
	has_many :comments, through: :posts

	acts_as_voter # les users peuvent mettre des likes sur les items

end
