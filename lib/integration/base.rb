module PrioriData
  module Integration
    class Base
      def self.load!
        self.new.load!
      end

      def load!
        PrioriData::DataLogger.info('Starting load data task.')

        load_categories
        load_rankings
        
        PrioriData::DataLogger.info('Data successfuly loaded to database.')
      end

      def load_categories
        PrioriData::DataLogger.info('  - Starting categories list import.')
        
        Categories.import
        
        PrioriData::DataLogger.info('  - Categories list successfuly imported.')
      end

      def load_rankings
        PrioriData::DataLogger.info('  - Starting rankings import task.')

        pool = Rankings.pool(size: 69)

        Category.all.each do |category|
          begin
            pool.future(:import, category.external_id)
          rescue PrioriData::AppleServiceNotAvailableException
            PrioriData::DataLogger.info "    - Error importing rankings for category: #{category.id} (#{category.name}). Apple Service Not Available."
          rescue PrioriData::AppleServiceChangedException
            PrioriData::DataLogger.info "    - Error importing rankings for category: #{category.id} (#{category.name}). Request returned an error status."
          end
        end

        PrioriData::DataLogger.info('  - Rankings successfuly imported.')
      end

      def self.http_exceptions
        [
          Timeout::Error, Errno::EINVAL, Errno::ECONNRESET,
          Errno::EHOSTUNREACH,Errno::ECONNREFUSED, EOFError,
          Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,
          Errno::ETIMEDOUT
        ]
      end
    end
  end
end
