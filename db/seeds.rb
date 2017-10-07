# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



user1 = User.create(name: "Luc", email:"vergeylen@vergeylen.eu", password:"dringg", :password_confirmation => 'dringg')
user2 = User.create(name: "Stéphane", email:"stephane@vergeylen.eu", password:"dringg", :password_confirmation => 'dringg')
user3 = User.create(name: "Daniel", email:"daniel@vergeylen.eu", password:"dringg", :password_confirmation => 'dringg')
user4 = User.create(name: "Vincent", email:"vincent@vergeylen.eu", password:"dringg", :password_confirmation => 'dringg')

c1 = Category.create(name: "Bandes dessinées", default_view: "list")
c2 = Category.create(name: "Livres", default_view: "list")
c3 = Category.create(name: "Films", default_view: "gallery")

# s3 = Series.create(name: "Merlin", category_id: c1.id)
# s4 = Series.create(name: "IRS", category_id: c1.id)
# s5 = Series.create(name: "Science-Fiction", category_id: c2.id)
# s6 = Series.create(name: "Historique", category_id: c2.id)
# s2 = Series.create(name: "Les Naufragés d'Ythaq", category_id: c1.id)
# s1 = Series.create(name: "Thorgal", category_id: c1.id)


# a1 = Author.create(name: "Rosinski")
# a2 = Author.create(name: "Van Hamme")
# a3 = Author.create(name: "Arleston")
# a4 = Author.create(name: "Floch")

# item1 = Item.create(numero: "1", name: "La Magicienne trahie", series_id: s1.id)
# item2 = Item.create(numero: "2", name: "L'Île des Mers gelées", series_id: s1.id)
# item3 = Item.create(numero: "3", name: "Les trois Veillards du pays d'Aran", series_id: s1.id)
# item4 = Item.create(numero: "4", name: "La Galère noire", series_id: s1.id)
# item5 = Item.create(numero: "5", name: "Au delà des Ombres", series_id: s1.id)
# item6 = Item.create(numero: "6", name: "La Chute de Brek Zarith", series_id: s1.id)
# item7 = Item.create(numero: "1", name: "Terra incognita ", series_id: s2.id)
# item8 = Item.create(numero: "2", name: "Ophyde la géminée", series_id: s2.id)
# item9 = Item.create(numero: "3", name: "Le Soupir des étoiles", series_id: s2.id)
# item10 = Item.create(numero: "4", name: "L'Ombre de Khengis", series_id: s2.id)
# item11 = Item.create(numero: "", name: "Le Cinquième Elément", series_id: s5.id)
# item12 = Item.create(numero: "", name: "Star Wars : Le Réveil de la Force", series_id: s5.id)
# item13 = Item.create(numero: "", name: "Ex Machina", series_id: s5.id)
# item13 = Item.create(numero: "", name: "Proteus", series_id: s5.id)
# item13 = Item.create(numero: "", name: "Valerian", series_id: s5.id)
# item13 = Item.create(numero: "", name: "Stargate", series_id: s5.id)

# Itemauthor.create(item_id: item1.id, author_id: a1.id)
# Itemauthor.create(item_id: item2.id, author_id: a1.id)
# Itemauthor.create(item_id: item3.id, author_id: a1.id)
# Itemauthor.create(item_id: item4.id, author_id: a1.id)
# Itemauthor.create(item_id: item5.id, author_id: a1.id)
# Itemauthor.create(item_id: item6.id, author_id: a1.id)
# Itemauthor.create(item_id: item1.id, author_id: a2.id)
# Itemauthor.create(item_id: item2.id, author_id: a2.id)
# Itemauthor.create(item_id: item3.id, author_id: a2.id)
# Itemauthor.create(item_id: item4.id, author_id: a2.id)
# Itemauthor.create(item_id: item4.id, author_id: a2.id)
# Itemauthor.create(item_id: item5.id, author_id: a2.id)
# Itemauthor.create(item_id: item7.id, author_id: a3.id)
# Itemauthor.create(item_id: item7.id, author_id: a4.id)
# Itemauthor.create(item_id: item8.id, author_id: a3.id)
# Itemauthor.create(item_id: item8.id, author_id: a4.id)

