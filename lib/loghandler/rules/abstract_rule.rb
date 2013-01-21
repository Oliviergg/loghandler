module Loghandler
  module Rules
    class AbstractRule
      def initialize(log_detail)
        raise "initialize is abstract. Provide an implementation"
      end
      def match?
        raise "match? is abstract. Provide an implementation"
      end
      def apply!
        raise "convert is abstract. Provide an implementation"
      end
      def log
        return nil
      end
      def show
        false
      end
      def persist
        raise "persist is abstract. Provide an implementation"
      end
    end
  end
end