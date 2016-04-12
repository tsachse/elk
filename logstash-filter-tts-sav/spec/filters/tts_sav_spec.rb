# encoding: utf-8
# https://github.com/logstash-plugins/logstash-filter-grok/blob/master/spec/filters/grok_spec.rb
#
require 'spec_helper'
require "logstash/filters/tts_sav"
require 'time'
require 'tzinfo' 

describe LogStash::Filters::TtsSav do
  describe "Telegrammbeschreibung einlesen" do
    let(:config) do <<-CONFIG
      filter {
        tts_sav {
        }
      }
    CONFIG
    end

    sample("BOFWT01TRKR08.03.1605:39:020442") do
      insist { subject["teltyp"] } == "BOF"
      insist { subject["datum"] } == "08.03.16"
      insist { subject["zeit"] } == "05:39:02"
      tz = TZInfo::Timezone.get('Europe/Berlin')
      insist { subject["@timestamp"] } == LogStash::Timestamp.new(tz.local_to_utc(Time.strptime("08.03.16 05:39:02", '%m.%d.%y %H:%M:%S')))
    end
  end

  describe "Telegrammblock vearbeiten" do
    let(:config) do <<-CONFIG
      filter {
        tts_sav {
        }
      }
    CONFIG
    end

    sample(["BOFWT01TRKR08.03.1605:39:020452","TG10675014002","EOF04520003"]) do
      expect(subject).to be_a(Array)
      insist { subject.size } == 3

      insist { subject[0]["teltyp"] } == "BOF"
      insist { subject[0]["datum"] } == "08.03.16"
      insist { subject[0]["zeit"] } == "05:39:02"
      tz = TZInfo::Timezone.get('Europe/Berlin')
      insist { subject[0]["@timestamp"] } == LogStash::Timestamp.new(tz.local_to_utc(Time.strptime("08.03.16 05:39:02", '%m.%d.%y %H:%M:%S')))

      insist { subject[1]["teltyp"] } == "TG1"
      insist { subject[1]["lfd_tag"] } == "067"
      insist { subject[1]["bat_nr"] } == "50"
      insist { subject[1]["sub_bat_nr"] } == "1"
      insist { subject[1]["trigger_typ"] } == "4"
      insist { subject[1]["fuellgrad"] } == "002"
      insist { subject[1]["@timestamp"] } == LogStash::Timestamp.new(tz.local_to_utc(Time.strptime("08.03.16 05:39:02", '%m.%d.%y %H:%M:%S')))
    end
  end

  describe "Unbekanntes Telegramm vearbeiten" do
    let(:config) do <<-CONFIG
      filter {
        tts_sav {
        }
      }
    CONFIG
    end

    sample(["BOFWT01TRKR08.03.1605:39:020452","???0675014002","EOF04520003"]) do
      expect(subject).to be_a(Array)
      insist { subject.size } == 3

      insist { subject[0]["teltyp"] } == "BOF"
      insist { subject[0]["datum"] } == "08.03.16"
      insist { subject[0]["zeit"] } == "05:39:02"
      tz = TZInfo::Timezone.get('Europe/Berlin')
      insist { subject[0]["@timestamp"] } == LogStash::Timestamp.new(tz.local_to_utc(Time.strptime("08.03.16 05:39:02", '%m.%d.%y %H:%M:%S')))

      insist { subject[1]["unbekannt"] } == "???"
      insist { subject[1]["@timestamp"] } == LogStash::Timestamp.new(tz.local_to_utc(Time.strptime("08.03.16 05:39:02", '%m.%d.%y %H:%M:%S')))
    end
  end

  describe "Falscher Zeitstempel im Telegrammblock vearbeiten" do
    let(:config) do <<-CONFIG
      filter {
        tts_sav {
        }
      }
    CONFIG
    end

    sample(["BOFWT01TRKR08003.1605:39:020452","TG10675014002","EOF04520003"]) do
      expect(subject).to be_a(Array)
      insist { subject.size } == 3

      insist { subject[0]["teltyp"] } == "BOF"
      insist { subject[0]["datum"] } == "08003.16"
      insist { subject[0]["datum_falsch"] } == "08003.16 05:39:02"


    end
  end

end
