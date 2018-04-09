#Use bundler to load gems
require 'bundler'

#load gems from Gemfile
Bundler.require 

#Load the app
require_relative 'get.rb'

require_relative 'extensions/string'

#Loads all the models in the models folder
Dir.glob('models/*.rb') do |model|
    require_relative model
end


Slim::Engine.set_options pretty: true, sort_attrs: false


use Rack::MethodOverride

#Run the app
run Get