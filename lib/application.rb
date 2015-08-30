require 'grape'

module PrioriData
  class API < Grape::API
    prefix "api"
    format "json"
 
    resource "hello" do
      get do
        'Hello world'
      end
    end
  end
end
