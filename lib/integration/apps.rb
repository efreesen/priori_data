require 'httparty'

module PrioriData
  module Integration
    class Apps
      attr_accessor :app_id
      BASE_URL = "https://itunes.apple.com/lookup"

      def initialize(app_id)
        @app_id = app_id
      end

      def self.import(app_id)
        self.new(app_id).import
      end

      def import
        app = PrioriData::Repositories::App.find(app_id)

        return app.publisher_id if app

        if response.success?
          json = JSON.parse(response.body)

          map_app(json)

          json["artist_id"]
        else
          raise PrioriData::AppleServiceChangedException
        end
      rescue *Base.http_exceptions
        raise PrioriData::AppleServiceNotAvailableException
      end

      def response
        @response ||= HTTParty.get(
            BASE_URL,
            query: query
          )
      end

      def map_app(json)
        PrioriData::Repositories::Publisher.persist(json)
        PrioriData::Repositories::App.persist(json)
      end

      private
      def query
        { id: app_id }
      end
    end
  end
end
