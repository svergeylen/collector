class User < ApplicationRecord
  	# Include default devise modules. Others available are:
  	# :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  	# Possession d'un item avec gestion des quantités
  	has_many :itemusers
	has_many :items, through: :itemusers

	# Series favorites
	has_and_belongs_to_many :series

	# News
	has_many :posts, dependent: :destroy
	has_many :comments, through: :posts

	acts_as_voter # les users peuvent mettre des likes sur les posts et les items

	has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>", tiny: "30x30>" }, default_url: "default-profile/:style.png"
	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

	def last_added_items(months_quantity)
		self.items.where(["quantity > ?", 0]).where(created_at: (Date.current-months_quantity.months)..Date.current).order(created_at: :desc)
	end

	# Renvoie un lien vers l'image par défaut pour les avatar parce que paperclip ne gère pas les avatar supprimés du disque (!)
	def friendly_avatar_url
		if self.avatar.exists?
			return self.avatar.url(:tiny)
		else
			return "default-profile/tiny.png"
		end
	end

	# Donne l'accès ou non à une ressource en fonction des droits de l'utilisateur
	def can?(res)
		resources = { collector: 5, une: 10, admin: 100 }
		if resources.include?(res)
			return  self.rights >= resources[res] 
		else
			return false
		end
	end

	# Ajout l'item à la collection de l'utilisateur
	# Si l'increment est négatif, la quantité d'item possédée est décrémentée
	def add_to_collection(item_id, increment = 1)
		increment = increment.to_i
		iu = self.itemusers.where(item_id: item_id).first
	
	    if iu.present?
	    	iu.quantity = [ (iu.quantity + increment), 0].max
	      	iu.save
	    else
	    	# Si l'utilisateur n'a pas encore l'item et que la quantité à ajouter est positive
	    	if (increment > 0)
	      		iu = self.itemusers.create(item_id: item_id, quantity: increment)
	      	end
	      	# Si l'utilisateur n'a pas l'item ET la quantité est nétagive... autant ne rien faire
	    end
    	return iu
	end

end
