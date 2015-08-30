require 'httparty'

module PrioriData
  module Integration
    class Categories
      URL = 'https://itunes.apple.com/WebObjects/MZStoreServices.woa/ws/genres'

      def self.import
        self.new.import
      end

      def import
        response = HTTParty.get(URL)

        if response.success?
          categories = JSON.parse(response.body)
        else
          raise PrioriData::AppleServiceChangedException
        end
      rescue *Base.http_exceptions
        raise PrioriData::AppleServiceNotAvailableException
      end
    end
  end
end
