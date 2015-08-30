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

        categories = JSON.parse(response.body)
      rescue *Base.http_exceptions
        raise PrioriData::AppleServiceNotAvailableException
      end
    end
  end
end
