class Note < ApplicationRecord
  belongs_to :item, touch: true

  validates  :message, :user_id, presence: true
end
