class Serie < ActiveRecord::Base
  	# Ancien site BD
  	self.table_name =  "bd_series"
	self.primary_key = "sid"

  	has_many :bds, foreign_key: "sid"
end