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
          resource: hash,
          error: error
        }
      end

      def hash
        return {} unless @resource

        {
          name: @resource.name,
          description: @resource.description,
          small_icon_url: @resource.small_icon_url,
          publisher_name: @resource.publisher.name,
          price: ('%.2f' % @resource.price),
          version_number: @resource.version,
          average_user_rating: ('%.2f' % @resource.average_user_rating)
        }
      end
    end
  end
end