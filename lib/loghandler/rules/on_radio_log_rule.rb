module Loghandler
  module Rules

    class OnRadioLogRule < AbstractRule
      def initialize(log_detail)
        @log_detail=log_detail
      end
      def match?
        # return true if (filename == "./log/access.log")
        return true if (@log_detail[:content].match(/Nouveau scan de page/))
        return false
      end
      def convert
        @log_detail.merge!({converted:true})
      end
      def log
        @log_detail.to_json
      end
      def persist?
        false
      end
      def showable?
        true
      end
      def to_show
        @log_detail.to_json
      end
    end

  end
end