class Auteur < ActiveRecord::Base
  # Ancien site BD
  self.table_name =  "bd_auteurs"
  self.primary_key = "aid"

  has_many :bdaids, foreign_key: "aid"
  has_many :bds, through: :bdaids
end