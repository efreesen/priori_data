module PrioriData
  module VOs
    class App
      def self.hash(resource)
        return {} if resource.blank?

        {
          name: resource.name,
          description: resource.description,
          small_icon_url: resource.small_icon_url,
          publisher_name: resource.publisher.name,
          price: ('%.2f' % resource.price),
          version_number: resource.version,
          average_user_rating: ('%.2f' % resource.average_user_rating)
        }
      end
    end
  end
end
