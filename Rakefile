require "bundler/setup"
require "grape/activerecord/rake"

namespace :db do
  # Some db tasks require your app code to be loaded
  task :environment do
    # If you set a custom db config in your app, you'll need to set it in your Rakefile too
    # Grape::ActiveRecord.database_file = "elsewhere/db.yml"

    require './lib/priori_data'
  end
end