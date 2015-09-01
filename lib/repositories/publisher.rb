module PrioriData::Repositories
  class Publisher
    attr_accessor :id, :name

    def initialize(params)
      @name = params["artistName"]
      @id   = params["artistId"]
    end

    def self.persist(params)
      self.new(params).persist
    end

    def persist
      validate_args

      resource.update_attributes(attributes)
    end

    def validate_args
      raise ArgumentError.new('ID must be passed') if id.nil? || ![String, Fixnum].include?(id.class)
      raise ArgumentError.new('Name must be passed') if name.nil? || !name.is_a?(String)
    end

    private
    def resource
      ::Publisher.where(external_id: id).first_or_initialize
    end

    def attributes
      { external_id: id, name: name }
    end
  end
end
