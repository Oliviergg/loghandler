require 'eventmachine'
require 'em-websocket'
require 'eventmachine-tail'
require 'socket'
require 'json'

require "loghandler/version"
require "loghandler/tailer"
require "loghandler/client"
require "loghandler/server"
require "loghandler/log_detail"

require "loghandler/rules/abstract_rule"
require "loghandler/rules/thin_access_log_rule"
require "loghandler/rules/on_radio_log_rule"
require "loghandler/rules/generic_log_rule"
require "loghandler/rules/generic_error_log_rule"

module Loghandler
end

# monkey patch
class String
  def underscore
    word = self.dup
    word.gsub!(/::/, '/')
    word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end
end