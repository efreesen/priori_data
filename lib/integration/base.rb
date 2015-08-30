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
        Categories.import
      end

      def load_rankings
        Category.all.each do |category|
          Rankings.import(category.id)
        end
      end

      def self.http_exceptions
        [
          Timeout::Error, Errno::EINVAL, Errno::ECONNRESET,
          Errno::EHOSTUNREACH,Errno::ECONNREFUSED, EOFError,
          Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError
        ]
      end
    end
  end
end
