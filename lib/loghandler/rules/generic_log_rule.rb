module Loghandler
  module Rules

    class GenericLogRule < AbstractRule
      def initialize(log_detail)
        @log_detail=log_detail
      end
      def match?
        return true if "generic_log" == @log_detail[:log_type]
        # return true if (@log_detail[:content].match(/RTL2/))
        return false
      end
      def apply!
      end
      def log
       @log_detail.to_json
      end
      def loggable?
        true
      end
      def persist?
        false
      end
      def showable?
        true
      end
    end

  end
end