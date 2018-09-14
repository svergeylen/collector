# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



user1 = User.create(name: "Luc", email:"vergeylen@vergeylen.eu", password:"dringgdringg", password_confirmation: "dringgdringg", rights: 10)
user2 = User.create(name: "Stéphane", email:"stephane@vergeylen.eu", password:"dringgdringg", password_confirmation: "dringgdringg", rights: 100)




