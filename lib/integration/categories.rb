require 'httparty'

module PrioriData
  module Integration
    class Categories
      URL = 'https://itunes.apple.com/WebObjects/MZStoreServices.woa/ws/genres'

      def self.import
        self.new.import
      end

      def import
        if response.success?
          json = JSON.parse(response.body)

          map_categories(json)
        else
          raise PrioriData::AppleServiceChangedException
        end
      rescue *Base.http_exceptions
        raise PrioriData::AppleServiceNotAvailableException
      end

      def response
        @response ||= HTTParty.get(URL)
      end

      def map_categories(json)
        json.each do |id, category|
          id = id.to_i
          subgenres = category.delete("subgenres")

          PrioriData::Repositories::Category.persist(id, category)

          map_categories(subgenres) if subgenres
        end
      end
    end
  end
end
