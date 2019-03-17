class Note < ApplicationRecord
  belongs_to :item, touch: true
  belongs_to :user

  validates  :user_id, presence: true
end
