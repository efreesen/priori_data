require "bundler/setup"
require "grape/activerecord/rake"

namespace :db do
  task :environment do
    require './lib/priori_data'
  end
end

task :setup => :"db:environment" do
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke

  PrioriData::Integration::Base.load!
end