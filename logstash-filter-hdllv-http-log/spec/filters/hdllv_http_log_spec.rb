# encoding: utf-8
# https://github.com/logstash-plugins/logstash-filter-grok/blob/master/spec/filters/grok_spec.rb
#
require 'spec_helper'
require "logstash/filters/hdllv_http_log"
require 'time'
require 'tzinfo' 

describe LogStash::Filters::HdllvHttpLog do
  describe "Felder splitten" do
    let(:config) do <<-CONFIG
      filter {
        hdllv_http_log {
        }
      }
    CONFIG
    end

    sample("2016.03.04 05:03:39 10.177.227.116 /akstat (GET)") do
      insist { subject["datum"] } == "2016/03/04"
      insist { subject["zeit"] } == "05:03:39"
      insist { subject["hostname"] } == "10.177.227.116"
      insist { subject["nachricht"] } == "/akstat (GET)"
      tz = TZInfo::Timezone.get('Europe/Berlin')
      insist { subject["@timestamp"] } == LogStash::Timestamp.new(tz.local_to_utc(Time.strptime('2016/03/04 05:03:39', '%Y/%m/%d %H:%M:%S')))
    end
  end

  describe "Folgezeilen bearbeiten" do
    let(:config) do <<-CONFIG
      filter {
        hdllv_http_log {
        }
      }
    CONFIG
    end

    sample(["2016.03.04 05:03:39 10.177.227.116 /akstat (GET)","Folgezeile"]) do
      expect(subject).to be_a(Array)
      insist { subject.size } == 2

      insist { subject[0]["datum"] } == "2016/03/04"
      insist { subject[0]["zeit"] } == "05:03:39"
      insist { subject[0]["hostname"] } == "10.177.227.116"
      insist { subject[0]["nachricht"] } == "/akstat (GET)"
      tz = TZInfo::Timezone.get('Europe/Berlin')
      insist { subject[0]["@timestamp"] } == LogStash::Timestamp.new(tz.local_to_utc(Time.strptime('2016/03/04 05:03:39', '%Y/%m/%d %H:%M:%S')))

      insist { subject[1]["datum"] } == "2016/03/04"
      insist { subject[1]["zeit"] } == "05:03:39"
      insist { subject[1]["hostname"] } == "10.177.227.116"
      insist { subject[1]["nachricht"] } == "Folgezeile"
      insist { subject[1]["@timestamp"] } == LogStash::Timestamp.new(tz.local_to_utc(Time.strptime('2016/03/04 05:03:39', '%Y/%m/%d %H:%M:%S')))
    end
  end

end
