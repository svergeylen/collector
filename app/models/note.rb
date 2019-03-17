class Note < ApplicationRecord
  belongs_to :item, touch: true

  validates  :user_id, presence: true
end
