module Loghandler
  module Rules
    class AbstractRule
      def initialize(log_detail)
        raise "initialize is abstract. Provide an implementation"
      end
      def match?
        raise "match? is abstract. Provide an implementation"
      end
      def convert
        raise "convert is abstract. Provide an implementation"
      end
      def persist
        raise "persist is abstract. Provide an implementation"
      end
    end
  end
end