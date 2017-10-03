class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :message, presence: true
  acts_as_votable # Les users peuvent liker des commentaires

end
