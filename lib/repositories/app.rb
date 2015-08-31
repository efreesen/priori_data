module PrioriData::Repositories
  class App
    def self.persist(params)
      raise ArgumentError.new('Params must be passed') if params.nil? || (params.respond_to?(:empty?) && params.empty?)

      resource = ::App.where(id: params["trackId"]).first_or_initialize

      resource.update_attributes(params)
    end

    def self.find(app_id)
      ::App.find(app_id)
    end
  end
end