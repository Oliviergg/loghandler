module Loghandler
  module Rules

    class GenericErrorLogRule < AbstractRule
      def initialize(log_detail)
        @log_detail=log_detail
      end
      def apply!
        @log_detail[:severity]="error"
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