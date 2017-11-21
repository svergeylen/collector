# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



user1 = User.create(name: "Luc", email:"vergeylen@vergeylen.eu", password:"d", :password_confirmation => 'd')
user2 = User.create(name: "Stéphane", email:"stephane@vergeylen.eu", password:"d", :password_confirmation => 'd')

c1 = Category.create(name: "Bandes dessinées", default_view: "list")
c2 = Category.create(name: "Livres", default_view: "list")
c3 = Category.create(name: "Films", default_view: "gallery")



