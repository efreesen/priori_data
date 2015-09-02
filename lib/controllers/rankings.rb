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
        error = @resources.any? ? nil : 'Resources not found.'

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
            app: PrioriData::VOs::App.hash(app)
          }
        end
      end
    end
  end
end