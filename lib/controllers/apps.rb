module PrioriData
  module Controllers
    class Apps
      def initialize(params)
        @params = params
        @resource = {}
      end

      def self.show(params)
        self.new(params).show
      end

      def show
        @resource = PrioriData::Repositories::Ranking.find_app(@params[:category_id], @params[:monetization], @params[:rank])

        response
      end

      def response
        error = @resource ? nil : 'Resource not found.'

        {
          resource: (@resource || {}),
          error: error
        }
      end
    end
  end
end