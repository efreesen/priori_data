module PrioriData
  module Controllers
    class Apps < Base
      def show
        if monetization_valid?
          @resource = PrioriData::Repositories::Ranking.find_app(params[:category_id], params[:monetization], params[:rank])
        else
          @message = 'Invalid monetization param, should be one of these: paid, free or grossing'
        end

        response
      end

      def response
        error = (resource || message) ? message : 'Resource not found.'

        {
          resource: PrioriData::VOs::App.hash(resource),
          error: error
        }
      end
    end
  end
end