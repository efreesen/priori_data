module PrioriData::Repositories
  class Ranking
    def initialize(category_id, monetization, rank, app_id, publisher_id)
      @category_id  = category_id
      @monetization = monetization
      @rank         = rank
      @app_id       = app_id
      @publisher_id = publisher_id
    end

    def self.persist(category_id, monetization, rank, app_id, publisher_id)
      self.new(category_id, monetization, rank, app_id, publisher_id).persist
    end

    def persist
      validate_args

      ranking = ::Ranking.where(category_id: category_id, monetization: monetization, rank: rank).first_or_initialize

      ranking.update_attributes(category_id: category_id, monetization: monetization, rank: rank, app_id: app_id, publisher_id: publisher_id)
    end

    def validate_args
      raise ArgumentError.new('category_id must be passed') if category_id.blank? || ![String, Fixnum].include?(category_id.class)
      raise ArgumentError.new('monetization must be passed') unless monetization
      raise ArgumentError.new("monetization must be one of these: #{monetization_options.join(', ')}") unless monetization_options.include? monetization
      raise ArgumentError.new('rank must be a fixnum') if rank.blank? || !rank.is_a?(Fixnum)
      raise ArgumentError.new('app_id must be passed') if app_id.blank? || ![String, Fixnum].include?(app_id.class)
      raise ArgumentError.new('publisher_id must be passed') if publisher_id.blank? || ![String, Fixnum].include?(publisher_id.class)
    end

    private
    attr_accessor :category_id, :monetization, :rank, :app_id, :publisher_id

    def monetization_options
      [:paid, :free, :grossing]
    end
  end
end