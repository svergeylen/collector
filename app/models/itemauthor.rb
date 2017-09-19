class Itemauthor < ApplicationRecord
  belongs_to :author
  belongs_to :item
end
