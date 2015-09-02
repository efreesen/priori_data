require 'httparty'
require 'celluloid/backported'

module PrioriData
  module Integration
    class Rankings
      include Celluloid

      Celluloid.shutdown_timeout = (20 * 60)

      BASE_URL = 'https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop'

      def import(category_id)
        @category_id = category_id

        if response.success?
          json = JSON.parse(response.body)

          map_rankings(json)
        else
          PrioriData::DataLogger.error "      - Request returned an error importing Rankings data from category #{category_id}: status: #{response.code}."
        end
      rescue *Base.http_exceptions
        PrioriData::DataLogger.error "      - Apple Service not available. Could not import Rankings data for category #{category_id}."
      end

      def map_rankings(json)
        json["topCharts"].each do |ranking|
          monetization = monetization_kinds[ranking["shortTitle"]]

          if monetization
            PrioriData::DataLogger.info "    - Importing #{monetization.to_s.capitalize} Ranking List for category: #{@category_id} (#{json["genre"]["name"]})"

            persist_data(ranking, monetization, ranking["adamIds"])
          end
        end
      end

      def response
        @response ||= HTTParty.get(
            BASE_URL,
            query: query,
            headers: headers
          )
      end

      def persist_data(ranking, monetization, app_ids_batch)
        publisher_ids = Apps.import(app_ids_batch)

        app_ids_batch.each_with_index do |app_id, index|
          publisher_id = publisher_ids[app_id.to_s]

          PrioriData::Repositories::Ranking.persist(@category_id, monetization, index + 1, app_id, publisher_id) if publisher_id
        end
      end

      private
      def headers
        @headers ||= begin
          {
            "Accept-Encoding"     => "gzip, deflate, sdch",
            "Accept-Language"     => "en-US,en;q=0.8,lv;q=0.6",
            "User-Agent"          => "iTunes/11.1.1 (Windows; Microsoft Windows 7 x64 Ultimate Edition Service Pack 1 (Build 7601)) AppleWebKit/536.30.1",
            "Accept"              => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
            "Cache-Control"       => "max-age=0",
            "X-Apple-Store-Front" => "143441-1,17"
          }
        end
      end

      def query
        @query ||= {
          genreId: @category_id,
          popId: 30,
          dataOnly: "true",
          l: "en"
        }
      end

      def monetization_kinds
        @monetization_kinds ||= {
          "Paid"         => :paid,
          "Free"         => :free,
          "Top Grossing" => :grossing
        }
      end
    end
  end
end
