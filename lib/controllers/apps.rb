module PrioriData
  module Controllers
    class Apps
      def initialize(params)
        @message = nil
        @params = params
        @resource = {}
      end

      def self.show(params)
        self.new(params).show
      end

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

      private
      attr_accessor :resource, :message, :params

      def monetization_valid?
        ['paid', 'free', 'grossing'].include?(params[:monetization])
      end
    end
  end
end