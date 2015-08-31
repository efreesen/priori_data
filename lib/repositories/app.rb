module PrioriData::Repositories
  class App
    def self.persist(category_id, params)
      raise ArgumentError.new('ID must be passed') unless id || id.is_a?(String) || id.is_a?(Fixnum)
      raise ArgumentError.new('Params must be passed') if params.nil? || (params.respond_to?(:empty?) && params.empty?)

      resource = ::App.where(id: params["id"]).first_or_initialize

      resource.update_attributes(params)
    end
  end
end