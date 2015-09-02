module PrioriData
  module Controllers
    class Base
      def initialize(params)
        @message = nil
        @params = params
        @resources = []
        @resource = {}
      end

      def self.index(params)
        self.new(params).index
      end

      def self.show(params)
        self.new(params).show
      end

      def index
        raise 'Override Me!!!'
      end

      def show
        raise 'Override Me!!!'
      end

      protected
      attr_accessor :resources, :resource, :message, :params

      def monetization_valid?
        ['paid', 'free', 'grossing'].include?(params[:monetization])
      end
    end
  end
end