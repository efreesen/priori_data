class App < ActiveRecord::Base
  belongs_to :publisher, primary_key: :external_id
  has_many :rankings
end