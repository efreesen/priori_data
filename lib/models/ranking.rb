class Ranking < ActiveRecord::Base
  belongs_to :app, primary_key: :external_id
  belongs_to :publisher, primary_key: :external_id
end