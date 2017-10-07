class Membre < ActiveRecord::Base
  # Ancien site BD
  self.table_name =  "bd_membres"
  self.primary_key = "pid"


end