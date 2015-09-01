module PrioriData
  module Controllers
    class Publishers
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

        require 'pry'; binding.pry

        grouped_resources.map do |ranking|
          publisher = ranking.publisher

          {
            publisher_id: publisher_id,
            publisher_name: publisher.name,
            rank: ,
            number of apps,
            app names
          }


          {
            rank: ranking.rank,
            app: {
              name: app.name,
              description: app.description,
              small_icon_url: app.small_icon_url,
              publisher_name: app.publisher.name,
              price: ('%.2f' % app.price),
              version_number: app.version,
              average_user_rating: ('%.2f' % app.average_user_rating)
            }
          }
        end
      end

      def grouped_resources
        @grouped_resources ||= begin
          @resources.group_by(&:publisher_id).map do |ranking|
            require 'pry'; binding.pry
            {
              publisher_id: publisher_id,
              publisher_name: publisher.name,
              number_of_apps: ,
              app_names: 
            }
          end
        end
      end
    end
  end
end