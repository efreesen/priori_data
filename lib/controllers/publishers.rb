module PrioriData
  module Controllers
    class Publishers
      def initialize(params)
        @message = nil
        @params = params
        @resources = []
      end

      def self.index(params)
        self.new(params).index
      end

      def index
        if monetization_valid?
          @resources = PrioriData::Repositories::Ranking.find_ranking(params[:category_id], params[:monetization])
        else
          @message = 'Invalid monetization param, should be one of these: paid, free or grossing'
        end

        response
      end

      def response
        error = (resources.any? || message) ? message : 'Resources not found.'

        {
          resources: PrioriData::VOs::Publisher.hash(resources),
          error: error
        }
      end

      private
      attr_accessor :resources, :message, :params

      def monetization_valid?
        ['paid', 'free', 'grossing'].include?(params[:monetization])
      end
    end
  end
end