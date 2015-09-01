module PrioriData::Repositories
  class App
    def self.persist(params)
      raise ArgumentError.new('Params must be passed') if params.nil? || (params.respond_to?(:empty?) && params.empty?)

      resource = ::App.where(external_id: params["trackId"]).first_or_initialize

      attributes = {
        external_id: params["trackId"],
        name: name(params),
        description: description(params),
        small_icon_url: params["artworkUrl60"],
        publisher_id: params["artistId"],
        price: params["price"],
        version: params["version"],
        average_user_rating: params["averageUserRating"]
      }

      resource.update_attributes(attributes)
    end

    def self.find(app_id)
      ::App.where(external_id: app_id).first
    end

    private
    def self.name(params)
      ActiveSupport::Inflector.transliterate params["trackName"]
    end

    def self.description(params)
      ActiveSupport::Inflector.transliterate(params["description"] || params["longDescription"] || '')
    end
  end
end