module PrioriData
  module Controllers
    class Rankings
      def initialize(params)
        @params = params
        @resources = []
      end

      def self.index(params)
        self.new(params).index
      end

      def index
        @resources = PrioriData::Repositories::Ranking.find_ranking(@params[:category_id], @params[:monetization])

        response
      end

      def response
        error = @resources ? nil : 'Resources not found.'

        {
          resources: hash,
          error: error
        }
      end

      def hash
        return [] if @resources.nil? || @resources.empty?

        @resources.map do |ranking|
          app = ranking.app

          {
            rank: ranking.rank,
            app: {
              name: app.name,
              description: app.description,
              small_icon_url: app.small_icon_url,
              publisher_name: app.publisher.name,
              price: ('%.2f' % (app.price || 0)),
              version_number: app.version,
              average_user_rating: ('%.2f' % (app.average_user_rating || 0))
            }
          }
        end
      end
    end
  end
end