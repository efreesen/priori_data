require 'active_record'
require 'yaml'

env = ENV["RACK_ENV"] || 'development'

db_options = YAML.load(File.read('./config/database.yml'))[env]
ActiveRecord::Base.establish_connection(db_options)

Dir["#{Dir.pwd}/lib/**/*.rb"].each {|file| require file }