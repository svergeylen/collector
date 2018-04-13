class Ownerfolder < ApplicationRecord
	belongs_to :owner, polymorphic: true
	belongs_to :folder
end