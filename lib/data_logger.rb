module PrioriData
  class DataLogger
    def self.instance
      @instance ||= Logger.new($stdout)
    end

    def self.debug(args)
      instance.debug(args)
    end

    def self.info(args)
      instance.info(args)
    end

    def self.warn(args)
      instance.warn(args)
    end

    def self.error(args)
      instance.error(args)
    end

    def self.fatal(args)
      instance.fatal(args)
    end

    def self.unknown(args)
      instance.unknown(args)
    end
  end
end
