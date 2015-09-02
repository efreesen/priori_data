module PrioriData
  module Controllers
    class Rankings < Base
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
          resources: PrioriData::VOs::Ranking.hash(resources),
          error: error
        }
      end
    end
  end
end