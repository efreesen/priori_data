module PrioriData::Repositories
  class Publisher
    attr_accessor :id, :name

    def initialize(params)
      @id   = params["artistId"]
      @name = params["artistName"]
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
      ::Publisher.where(id: id).first_or_initialize
    end

    def attributes
      { name: name }
    end
  end
end
