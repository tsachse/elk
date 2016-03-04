# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require File.dirname(__FILE__) + '/../helpers/' + 'dueb_helper.rb'
require 'time'

# Der Filter dient zum Verarbeiten von errlog-Dateien
class LogStash::Filters::Errlog < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   errlog {
  #   }
  # }
  #
  config_name "errlog"
  

  public
  def initialize(config = {})
    super

    # Der Filter kann nicht parallelsiert werden, da Folgezeilen
    # bearbeiten werden sollen bzw. Beziehungen zwischen den Zeilen bestehen
    @threadsafe = false
  end

  def register
    # Add instance variables 
    @datum    = '2000/01/01' 
    @zeit     = '00:00:00' 
    @hostname = 'X'
    @pid      = 0
    @nutzer   = 'X'
    @programm = 'X'

    @dueb_helper = DuebHelper.new
  end # def register

  public
  def filter(event)

    f = event["message"].split("\t")

    if(f[0] =~ /^\d+\/\d+\/\d+$/)
      # normale Zeile
      @datum    = event["datum"] = f.shift
      @zeit     = event["zeit"] = f.shift
      @hostname = event["hostname"] = f.shift
      @pid      = event["pid"] = f.shift
      @nutzer   = event["nutzer"] = f.shift
      @programm = event["programm"] = f.shift
    else
      # Folgezeile
      event["datum"] = @datum
      event["zeit"] = @zeit
      event["hostname"] = @hostname
      event["pid"] = @pid
      event["nutzer"] = @nutzer
      event["programm"] = @programm
    end

    event["nachricht"] = f.join("\t")
    event["@timestamp"] = LogStash::Timestamp.new(Time.strptime("#{event["datum"]} #{event["zeit"]}", '%Y/%m/%d %H:%M:%S'))

    # Ereignisse Datenuebernahme untersuchen
    @dueb_helper.parse(event)

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Errlog
