# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '2.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules', "lib", "vendor")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( vendor/assets/javascripts/selectize.js-master/dist/js/selectize.min.js, vendor/assets/javascripts/selectize.js-master/dist/css/selectize.css, vendor/assets/javascripts/selectize.js-master/dist/css/selectize.bootstrap4.css )
