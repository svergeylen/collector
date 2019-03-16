class Task < ApplicationRecord
  belongs_to :item

  validates  :message, :user_id, presence: true
end
