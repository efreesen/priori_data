module PrioriData::Repositories
  class Ranking
    def self.persist(category_id, monetization, rank, app_id, publisher_id)
      raise ArgumentError.new('category_id must be passed') unless category_id || category_id.is_a?(String) || category_id.is_a?(Fixnum)
      raise ArgumentError.new('monetization must be passed') unless monetization
      raise ArgumentError.new("monetization must be one of these: #{monetization_options.join(', ')}") unless monetization_options.include? monetization
      raise ArgumentError.new('rank must be a fixnum') unless rank || rank.is_a?(Fixnum)
      raise ArgumentError.new('app_id must be passed') unless app_id || app_id.is_a?(String) || app_id.is_a?(Fixnum)
      raise ArgumentError.new('publisher_id must be passed') unless publisher_id || publisher_id.is_a?(String) || publisher_id.is_a?(Fixnum)
    end

    private
    def self.monetization_options
      [:paid, :free, :grossing]
    end
  end
end