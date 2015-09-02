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
        grouped = resources.group_by(&:publisher_id).map do |publisher_id, apps|
          attributes(publisher_id, apps)
        end

        grouped.sort_by{ |ranking| ranking[:number_of_apps] }.reverse!
      end

      def self.attributes(publisher_id, apps)
        {
          publisher_id: publisher_id,
          publisher_name: apps.first.publisher.name,
          number_of_apps: apps.count,
          app_names: apps.map{ |r| r.app.name }
        }
      end
    end
  end
end
