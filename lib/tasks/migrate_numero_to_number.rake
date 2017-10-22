namespace :db do
  desc "Conversion des numéros string en number integer"
  task numero_to_number: :environment do
  	puts "Conversion des numéros string en number integer"
  	
    Item.all.each do |item|
      puts "."
      item.update_attribute(:number,  item.numero.to_f)
    end

    puts "Fini !"
  end
end
