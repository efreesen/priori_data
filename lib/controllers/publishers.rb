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

        grouped_resources.each_with_index.map do |publisher, index|
          {
            rank: index + 1,
            publisher: publisher
          }
        end
      end

      def grouped_resources
        @grouped_resources ||= begin
          grouped = @resources.group_by(&:publisher_id).map do |ranking|
            {
              publisher_id: ranking.last.first.publisher_id,
              publisher_name: ranking.last.first.publisher.name,
              number_of_apps: ranking.last.count,
              app_names: ranking.last.map{ |r| r.app.name }
            }
          end

          grouped.sort_by{ |ranking| ranking[:number_of_apps] }.reverse!
        end
      end
    end
  end
end