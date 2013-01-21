module Loghandler
  module Rules

    class ThinAccessLogRule < AbstractRule
      def initialize(log_detail)
        @log_detail=log_detail
      end
      def match?
        # return true if (filename == "./log/access.log")
        return true if (@log_detail[:content].match(/RTL2/))
        return false
      end
      def convert
        return @log_detail.merge({converted:true})
      end
    end

  end
end