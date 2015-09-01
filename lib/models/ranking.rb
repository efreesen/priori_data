class Ranking < ActiveRecord::Base
  belongs_to :app, primary_key: :external_id
end