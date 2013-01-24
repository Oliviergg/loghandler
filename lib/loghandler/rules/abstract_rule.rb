module Loghandler
  module Rules
    class AbstractRule
      def initialize(log_detail)
        raise "initialize is abstract. Provide an implementation"
      end
      def match?
        return true if self.class.name.underscore == ["loghandler/rules/",@log_detail[:log_type], "_rule"].join
        return false
      end
      def apply!
        raise "convert is abstract. Provide an implementation"
      end
      def loggable?
        true
      end
      def persist?
        raise "persist is abstract. Provide an implementation"
      end
    end
  end
end