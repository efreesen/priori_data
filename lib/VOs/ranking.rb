module PrioriData
  module VOs
    class Ranking
      def self.hash(resources)
        return [] if resources.blank?

        resources.map do |ranking|
          app = ranking.app

          {
            rank: ranking.rank,
            app: PrioriData::VOs::App.hash(app)
          }
        end
      end
    end
  end
end
