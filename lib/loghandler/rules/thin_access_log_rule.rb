module Loghandler
  module Rules

    class ThinAccessLogRule < AbstractRule
      def initialize(log_detail)
        @log_detail=log_detail
      end
      def apply!
        log_detail = {}
        tmp = CSV.parse(@log_detail[:content],col_sep:" ")
        tmp = tmp[0]
        log_detail[:ip] = tmp[0]
        log_detail[:date] = tmp[3]+tmp[4]
        log_detail[:url]=tmp[5]
        log_detail[:status]=tmp[6].to_i
        log_detail[:length]=tmp[7].to_i
        log_detail[:referer]=tmp[8]
        log_detail[:user_agent]=tmp[9]
        #p  [log_detail[:url],log_detail[:status]]
        @log_detail.merge!(log_detail)
        if @log_detail[:status]>=500
          @log_detail[:severity]="error"
        elsif @log_detail[:status]>=400
          @log_detail[:severity]="warning"
        else
          @log_detail[:severity]="none"
        end
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