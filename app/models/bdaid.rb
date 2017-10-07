class Bdaid < ActiveRecord::Base
  # Ancien site BD
  self.table_name =  "bd_bdaid"

  belongs_to :bd, foreign_key: "bdid", primary_key: "bdid"
  belongs_to :auteur, foreign_key: "aid", primary_key: "aid"

end