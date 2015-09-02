require 'grape'
require './lib/priori_data'

module PrioriData
  class API < Grape::API
    prefix "api"
    format "json"
 
    resource :rankings do
      params do
        requires :category_id, type: Integer, desc: "Category id."
        requires :monetization, type: String, desc: "Monetization kind.", values: ['paid', 'free', 'grossing']
      end

      get ':category_id/:monetization' do
        Controllers::Rankings.index(params)
      end
    end

    resource :apps do
      params do
        requires :category_id, type: Integer, desc: "Category id."
        requires :monetization, type: String, desc: "Monetization kind.", values: ['paid', 'free', 'grossing']
        requires :rank, type: Integer, desc: "App rank on the list."
      end

      get ':category_id/:monetization/:rank' do
        Controllers::Apps.show(params)
      end
    end
 
    resource :publishers do
      params do
        requires :category_id, type: Integer, desc: "Category id."
        requires :monetization, type: String, desc: "Monetization kind.", values: ['paid', 'free', 'grossing']
      end

      get ':category_id/:monetization' do
        Controllers::Publishers.index(params)
      end
    end
  end
end
