class Ownertag < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :tag
end
