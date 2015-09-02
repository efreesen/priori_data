require 'httparty'

module PrioriData
  module Integration
    class Apps
      attr_accessor :app_ids
      BASE_URL = "https://itunes.apple.com/lookup"

      def initialize(app_ids)
        @app_ids = app_ids
      end

      def self.import(app_ids)
        self.new(app_ids).import
      end

      def import
        if response.success?
          json = JSON.parse(response.body)
          publisher_ids = {}

          json["results"].each do |app|
            map_app(app)
            publisher_ids[app["trackId"].to_s] = app["artistId"]
          end

          publisher_ids
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
        { id: app_ids.join(',') }
      end
    end
  end
end
