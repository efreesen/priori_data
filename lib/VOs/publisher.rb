module PrioriData
  module VOs
    class Publisher
      def self.hash(resources)
        return [] if resources.blank?

        grouped_resources(resources).each_with_index.map do |publisher, index|
          {
            rank: index + 1,
            publisher: publisher
          }
        end
      end

      def self.grouped_resources(resources)
        grouped = resources.group_by(&:publisher_id).map do |ranking|
          attributes(ranking)
        end

        grouped.sort_by{ |ranking| ranking[:number_of_apps] }.reverse!
      end

      def self.attributes(ranking)
        {
          publisher_id: ranking.last.first.publisher_id,
          publisher_name: ranking.last.first.publisher.name,
          number_of_apps: ranking.last.count,
          app_names: ranking.last.map{ |r| r.app.name }
        }
      end
    end
  end
end
