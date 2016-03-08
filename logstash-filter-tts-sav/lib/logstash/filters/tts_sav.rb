# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require "time"

# require File.dirname(__FILE__) + '/../helpers/' + 'dueb_helper.rb'

# Der Filter dient zum Verarbeiten von tts-sav-Dateien
class LogStash::Filters::TtsSav < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   tts_sav {
  #   }
  # }
  #
  config_name "tts_sav"
  

  public
  def initialize(config = {})
    super

    # Der Filter kann nicht parallelsiert werden, da Folgezeilen
    # bearbeiten werden sollen bzw. Beziehungen zwischen den Zeilen bestehen
    @threadsafe = false
  end

  def register
    # Add instance variables 
    #@datum    = '2000.01.01' 
    #@zeit     = '00:00:00' 
    #@hostname = 'X'
    @zeit = Hash.new
    @config = parse_config

  end # def register

  public
  def filter(event)
    telegramm_split(event)

    path = event["path"] || '____'
    if event.include?('teltyp') && event["teltyp"] == "BOF"
      @zeit[path] = event["@timestamp"] = LogStash::Timestamp.new(Time.strptime("#{event["datum"]} #{event["zeit"]}", '%m.%d.%y %H:%M:%S'))
    else
      event["@timestamp"] = @zeit[path]
    end

    if !event.include?('teltyp')
      event["teltyp"] = "---"
    end



    # f = event["message"].split("\s")

    #event["@timestamp"] = LogStash::Timestamp.new(Time.strptime("#{event["datum"]} #{event["zeit"]}", '%Y.%m.%d %H:%M:%S'))

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter

  def parse_config
    c = Hash.new
    fn = File.dirname(__FILE__) + '/' + 'telegramme.config'  
    tel = 'XXX'
    pos = 0
    File.open(fn,"r:ISO8859-1").each do |line|
      # puts line
      if line =~ /^\[(.+)\]/
	tel = $1
	c[tel] = Array.new
	c[tel].push(['teltyp', 0, tel.size])
	pos = tel.size
      end
      if line =~ /^\s+([\w_\d]+)\s+\w\s+(\d+)/
	feld_name = $1
	laenge = $2.to_i
	c[tel].push([feld_name, pos, laenge])
	pos = pos + laenge
      end
    end
    c
  end

  def telegramm_split(event)
    message = event["message"]
    @config.keys.each do |tel|
      if message =~ /^#{tel}/
	@config[tel].each do |feld|
	  (name, pos, laenge) = feld
	  event[name] = message[pos, laenge]
	end
      end
    end
  end

end # class LogStash::Filters::TtsSav
