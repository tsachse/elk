# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require "date"

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
  end # def register

  public
  def filter(event)

    f = event["message"].split("\t")
    event["datum"] = f.shift
    event["zeit"] = f.shift
    event["hostname"] = f.shift
    event["pid"] = f.shift
    event["nutzer"] = f.shift
    event["programm"] = f.shift
    event["nachricht"] = f.join("\t")
    # event["@timestamp"] = LogStash::Timestamp.parse_iso8601(DateTime.strptime("#{event["datum"]} #{event["zeit"]}+01:00", '%Y/%m/%d %H:%M:%S%z').to_s)
    event["@timestamp"] = LogStash::Timestamp.new(Time.strptime("#{event["datum"]} #{event["zeit"]}+01:00", '%Y/%m/%d %H:%M:%S%z'))

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Errlog
