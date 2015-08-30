module PrioriData
  module Integration
    class Base
      def self.load!
        self.new.load!
      end

      def load!
        load_categories
      end

      def load_categories
      end
    end
  end
end
