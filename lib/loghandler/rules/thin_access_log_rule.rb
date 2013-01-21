module Loghandler
  module Rules

    class ThinAccessLogRule < AbstractRule
      def initialize(log_detail)
        @log_detail=log_detail
      end
      def match?
        return true if (@log_detail[:log_type] ="thin_access_log")
        # return true if (@log_detail[:content].match(/RTL2/))
        return false
      end
      def apply!
        log_detail = {}
        tmp = CSV.parse(@log_detail,col_sep:" ")
        tmp = tmp[0]
        log_detail[:ip] = tmp[0]
        log_detail[:date] = tmp[3]+tmp[4]
        log_detail[:url]=tmp[5]
        log_detail[:status]=tmp[6]
        log_detail[:length]=tmp[7]
        log_detail[:referer]=tmp[8]
        log_detail[:user_agent]=tmp[9]
        #p  [log_detail[:url],log_detail[:status]]

        @log_detail.merge!(log_detail)
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