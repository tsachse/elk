# encoding: utf-8
# https://github.com/logstash-plugins/logstash-filter-grok/blob/master/spec/filters/grok_spec.rb
#
require 'spec_helper'
require "logstash/filters/errlog"
require 'date'

describe LogStash::Filters::Errlog do
  describe "Felder splitten" do
    let(:config) do <<-CONFIG
      filter {
        errlog {
        }
      }
    CONFIG
    end

    sample("2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb_ftp.pl\tSIGTERM erhalten") do
      insist { subject["datum"] } == "2016/01/29"
      insist { subject["zeit"] } == "10:05:12"
      insist { subject["hostname"] } == "ddhpit01"
      insist { subject["pid"] } == "11773"
      insist { subject["nutzer"] } == "hdllv"
      insist { subject["programm"] } == "dueb_ftp.pl"
      insist { subject["nachricht"] } == "SIGTERM erhalten"
      insist { subject["@timestamp"] } == LogStash::Timestamp.new(Time.strptime('2016/01/29 10:05:12+01:00', '%Y/%m/%d %H:%M:%S%z'))
    end
  end

  describe "Folgezeilen behandeln" do
    let(:config) do <<-CONFIG
      filter {
        errlog {
        }
      }
    CONFIG
    end

    sample(["2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb_ftp.pl\tSIGTERM erhalten","Folgezeile"]) do
      expect(subject).to be_a(Array)
      insist { subject.size } == 2

      insist { subject[0]["datum"] } == "2016/01/29"
      insist { subject[0]["zeit"] } == "10:05:12"
      insist { subject[0]["hostname"] } == "ddhpit01"
      insist { subject[0]["pid"] } == "11773"
      insist { subject[0]["nutzer"] } == "hdllv"
      insist { subject[0]["programm"] } == "dueb_ftp.pl"
      insist { subject[0]["nachricht"] } == "SIGTERM erhalten"
      insist { subject[0]["@timestamp"] } == LogStash::Timestamp.new(Time.strptime('2016/01/29 10:05:12+01:00', '%Y/%m/%d %H:%M:%S%z'))

      insist { subject[1]["datum"] } == "2016/01/29"
      insist { subject[1]["zeit"] } == "10:05:12"
      insist { subject[1]["hostname"] } == "ddhpit01"
      insist { subject[1]["pid"] } == "11773"
      insist { subject[1]["nutzer"] } == "hdllv"
      insist { subject[1]["programm"] } == "dueb_ftp.pl"
      insist { subject[1]["nachricht"] } == "Folgezeile"
      insist { subject[1]["@timestamp"] } == LogStash::Timestamp.new(Time.strptime('2016/01/29 10:05:12+01:00', '%Y/%m/%d %H:%M:%S%z'))
    end
  end
end
