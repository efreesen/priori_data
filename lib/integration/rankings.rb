require 'httparty'

module PrioriData
  module Integration
    class Rankings
      BASE_URL = 'https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop'

      def initialize(category_id)
        @category_id = category_id
      end

      def self.import(category_id)
        self.new(category_id).import
      end

      def import
        response = HTTParty.get(
          BASE_URL,
          query: query,
          headers: headers
        )

        if response.success?
          json = JSON.parse(response.body)

          map_rankings(json)
        else
          raise PrioriData::AppleServiceChangedException
        end
      rescue *Base.http_exceptions
        raise PrioriData::AppleServiceNotAvailableException
      end

      def map_rankings(json)
        json["topCharts"].each do |ranking|
          monetization = monetization_kinds[ranking["title"]]

          ranking["adamIds"].each_with_index do |app_id, index|
            Apps.import(app_id)

            PrioriData::Repositories::Ranking.persist(@category_id, monetization, index+1, app_id)
          end
        end
      end

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

      private
      def monetization_kinds
        @monetization_kinds ||= {
          "Top Paid iPhone Apps"     => :paid,
          "Top Free iPhone Apps"     => :free,
          "Top Grossing iPhone Apps" => :grossing
        }
      end
    end
  end
end
