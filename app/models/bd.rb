class Bd < ActiveRecord::Base
  # Ancien site BD
  self.table_name =  "bd_bd"
  self.primary_key = "bdid"

  has_one :serie, foreign_key: "sid"

  has_many :bdaids, foreign_key: "bdid"
  has_many :auteurs, through: :bdaids

  # Renvoie true si l'utilisateur possède la BD
  def is_owned_by(user_id)
  	b = self.send("PID#{user_id}")
  	if b.present?
  		return (b.to_i == 1)
  	else
  		return false
  	end
  end
end