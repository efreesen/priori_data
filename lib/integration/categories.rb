require 'httparty'

module PrioriData
  module Integration
    class Categories
      URL = 'https://itunes.apple.com/WebObjects/MZStoreServices.woa/ws/genres'

      def self.valid_categories
        [36, 6000, 6001, 6002, 6003, 6004, 6005, 6006, 6007, 6008, 6009, 6010, 6011, 6012, 6013, 6014, 6015, 6016, 6017, 6018, 6020, 6021, 6022, 7001, 7002, 7003, 7004, 7005, 7006, 7007, 7008, 7009, 7010, 7011, 7012, 7013, 7014, 7015, 7016, 7017, 7018, 7019, 13001, 13002, 13003, 13004, 13005, 13006, 13007, 13008, 13009, 13010, 13011, 13012, 13013, 13014, 13015, 13017, 13018, 13019, 13020, 13021, 13023, 13024, 13025, 13026, 13027, 13028, 13029, 13030]
      end

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

          next unless self.class.valid_categories.include?(id)

          subgenres = category.delete("subgenres")

          PrioriData::Repositories::Category.persist(id, category)

          map_categories(subgenres) if subgenres && subgenres.any?
        end
      end
    end
  end
end
