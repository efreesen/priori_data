require "bundler/setup"
require "grape/activerecord/rake"

namespace :db do
  task :environment do
    require './lib/priori_data'
  end
end

task :load => :"db:environment" do
  PrioriData::Integration::Base.load!
end

task :setup => :"db:environment" do
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
  Rake::Task['load'].invoke
end