class Item < ApplicationRecord
	belongs_to :folder

	has_many :itemusers
	has_many :users,        through:    :itemusers
	belongs_to :adder,      class_name: "User"

	has_many :attachments,  as:         :element,   dependent: :destroy
	accepts_nested_attributes_for :attachments

	has_many :notes,   dependent: :destroy

	has_and_belongs_to_many :tags

	validates :name, presence: true
	validates :adder_id, presence: true

	# --------------------- VIRTUAL ATTRIBUTES ---------------------------------------------------------------------------

	attr_writer :tag_names 			# tags form item générique
	before_save :save_tags

	# Donne la liste de tags de l'item au format string séparé par une virgule
	def tag_names
		@tag_names || tags.pluck(:name).join(", ")
	end

	# Before_save : Sauvegarde les tags donnés dans une liste de string séparée par des virgule en objets Tag
	def save_tags
		if @tag_names
			tags = []
			@tag_names.split(",").each do |name| 
				#logger.debug "---> "+name.to_s
				name = name.strip
				next if name==""
				new_tag = Tag.where(name: name).first_or_create!
				# BUG ici si on tente de créer un tag qui porte le même nom d'auteur sans les majuscules
				# car le tag n'est pas créé et le save foire
				tags << new_tag # unless tags.include?(new_tag)
			end
			# J'écrase tous les tags existants. C'est différent de la méthode add_tags qui ajoute des tags
			self.tags = tags
		end
	end

	
	# Donne LE nom de la série de l'item dont le parent tag est donné.
	# Pour Bonsais : parent_name = "Espèces" --> renvoie le premier tags enfant de "Espèces"
	#def tag_serie_by(parent_name)
	#	@tag_series || tags_with_parent(parent_name).first
	#end

	# --------------------- TAGS ---------------------------------------------------------------------------

	# Ajoute l'array de tag_names à l'item sans créer de doublon. Crée les tags si inexistants.
	# Différent de save_tags qui écrase les tags existants par les tags donnés.
#	def add_tags(tag_names_array)
#		tag_names_array.each do |tag_name|
#			tag_name = tag_name.strip
#			if tag_name!=""
#				tag = Tag.where(name: tag_name).first_or_create!
#				self.tags << tag unless self.tags.include?(tag)
#			end
#		end
#	end

	# Supprime l'association entre l'item et le tableau de tag_names donné
#	def remove_tags(tag_names_array)
#		tag_names_array.each do |tag_name|
#			tag_name = tag_name.strip
#			if tag_name!=""
#				tag = Tag.find_by(name: tag_name)
#				self.tags.delete(tag) if tag.present?
#			end
#		end
#	end

	# Renvoie les Items correspondants à l'array de tag_ids donné
	# order = "date" permet de trier par date au lieu de trier par numéro
#	def self.having_tags(ar_tags, order)
#	  	# On sélectionne dans les tags donnés uniquement ceux qui doivent filtrer les items
#	  	applicable_tag_ids = Tag.where(id: ar_tags).where(filter_items: true).pluck(:id)
#	  	# On sélectionne les items qui correspondent à ces tags filtrants en comptant si chaque item est repris autant de fois que le nombre de tags filtrants donné
#	  	# Si il y a deux tags filtrants donnés, il faut que ownertags contiennent 2 lignes pour cet item (une ligne pour chaque tag différent)
#	  	ownertags = Ownertag.where(tag_id: applicable_tag_ids, owner_type: "Item").group(:owner_id).count.select{|owner_id, value| value == applicable_tag_ids.size }
#	  	# Les items correspondant aux ownertags reçus, classés par ordre de numéros
#	  	# .includes(:tags, itemusers: [:user])
#	  	if order == "date"
#	  		return Item.where(id: ownertags.keys).order(updated_at: :desc)
#	  	else
#			return Item.where(id: ownertags.keys).sort_by { |a| [a.number.to_f, a.name] }
#		end
#	end


	# ------------------ POSSESSION de l'ITEM ----------------------------------------------------------------
	# Renvoie true si n'importe qui possède cet item (utile pour savoir si la famille possède ou non l'item)
	def is_owned?
		return (self.itemusers.where("quantity > ?", 0).count > 0)
	end

	# Renvoie true si l'utilisateur possède cet item
	def is_owned_by?(user_id)
		return (self.quantity_for(user_id) > 0)
	end

	# Renvoie le nombre d'items identiques possédés par l'utilisateur donné
	def quantity_for(user_id)
		iu = self.itemusers.where(user_id: user_id).first
		if iu.present?
			return iu.quantity
		else
			return 0
		end
	end

	# --------------------  CHAMPS de l'ITEM -------------------------------------------------------------
	# Renvoie le string du numéro de l'item (integer ou float suivant les cas)
	def friendly_number
		if self.number.present?
			if (self.number.round(0) == self.number)
				ret = self.number.round(0).to_s
			else
				ret = self.number.to_s
			end
		end
		return ret
	end

	# --------------------------- RECHERCHE -------------------------------------------------------------
	# Recherche les items contenant le mot clé donné
	def self.search(keyword)
		keyword = keyword.downcase
		if keyword.present?
		  where('name LIKE ?', "%#{keyword}%").order(name: :asc)
		else
		  all
		end
	end

	# -------------- Items appartenant à un folder root donné  -------------------------
	def self.belongs_to_folder(root_folder)
		# Renvoie tous les items dont le folder se trouve parmi n'importe quel descendant de la racine donnée
		where(folder: root_folder.descendant_ids)
	end


	# -------------- Enrichissement via site tiers ------------------------------------------
	

    # Charge du contenu distant depuis un site tiers, en fonction du type d'item (item_type)
    def enhance
		require 'open-uri'
	    require 'nokogiri'
	    puts "------------> "+self.name+" : Enhance. Item_type="+self.item_type

	    case self.item_type
	      when "bd", "livre"
	      	series = self.tag_series
			books = GoogleBooks.search(self.name+" - "+series, {:count => 10})
			
			book = books.first
			content = ""
			content+= "Auteurs : "+book.authors if book.authors.present?
			content+= "<br />ISBN : "+book.isbn if book.isbn.present?
			content+= "<br />Description : "+book.description if book.description.present?
			content+= "<br />Publié le : "+book.published_date if book.description.present?
			content+= "<br />preview_link : "+book.preview_link if book.preview_link.present?
			content+= "<br />Info_link : "+book.info_link if book.info_link.present?
			image_src = book.image_link(:zoom => 2)

	      when "bonsai", "plante"


	      when "film"
	      

	      when "jeu" # Jeux de société
	        name = self.name.downcase
	        # Page de garde du jeu
	        page = fetch_page("https://www.trictrac.net/jeu-de-societe/"+name)
	        image_src = page.at_css("#img-game").attributes["src"]
	        content1 = page.at_css("#content-column")
	      	content = content1

	      when "piece" 

	      else # Items, modélisme

	    end 

	    # Sauvegarde des données rassemblées
	    self.enhanced_image = image_src if image_src.present?
	    self.enhanced_content = content if content.present?
	    self.save
    end


private
    # Récupère la page distante et instancie Nokogiri pour le parsing de la page
    def fetch_page(url)
      return Nokogiri::HTML(open(url))   
    end

end
