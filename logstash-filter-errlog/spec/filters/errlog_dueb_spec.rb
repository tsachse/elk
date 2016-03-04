# encoding: UTF-8
# https://github.com/logstash-plugins/logstash-filter-grok/blob/master/spec/filters/grok_spec.rb
#
require 'spec_helper'
require "logstash/filters/errlog"
require 'time'

describe LogStash::Filters::Errlog do
  describe "DUEB Ereignisse" do
    let(:config) do <<-CONFIG
      filter {
        errlog {
        }
      }
    CONFIG
    end

    sample("2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb\tLVS 049/1 begonnen") do
      insist { subject["nachricht"] } == "LVS 049/1 begonnen"
      insist { subject["gewerk"] } == "DUEB"
      insist { subject["ereignis"] } == "Datenuebertragung begonnen"
      insist { subject["ereignis_code"] } == "datenuebertragung_begonnen"
      insist { subject["lv_tag"] } == 49
      insist { subject["lv_scheibe"] } == 1
    end

    sample("2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb\tCLS-File shipments_hdl_16049_utc131312_sam.xml empfangen - Umbenennung nach dat704915.xml") do
      insist { subject["nachricht"] } == "CLS-File shipments_hdl_16049_utc131312_sam.xml empfangen - Umbenennung nach dat704915.xml"
      insist { subject["gewerk"] } == "DUEB"
      insist { subject["ereignis"] } == "Daten von CLS eingetroffen"
      insist { subject["lv_tag"] } == 49
      insist { subject["lv_scheibe"] } == 1
    end

    sample("2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb\tAbruf ID 568 LVS 49/1 im Auftragspuffer gefunden") do
      insist { subject["nachricht"] } == "Abruf ID 568 LVS 49/1 im Auftragspuffer gefunden"
      insist { subject["gewerk"] } == "DUEB"
      insist { subject["ereignis"] } == "Daten im Auftragspuffer gefunden"
      insist { subject["lv_tag"] } == 49
      insist { subject["lv_scheibe"] } == 1
    end

    sample("2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb_ftp.pl\tLVS 49/1 vollstaendig") do
      insist { subject["nachricht"] } == "LVS 49/1 vollstaendig"
      insist { subject["gewerk"] } == "DUEB"
      insist { subject["ereignis"] } == "Daten fuer LV vollstaendig"
      insist { subject["lv_tag"] } == 49
      insist { subject["lv_scheibe"] } == 1
    end

    sample("2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb_main.pl\tStart Tag 049, Scheibe 1") do
      insist { subject["nachricht"] } == "Start Tag 049, Scheibe 1"
      insist { subject["gewerk"] } == "DUEB"
      insist { subject["ereignis"] } == "Import Start"
      insist { subject["lv_tag"] } == 49
      insist { subject["lv_scheibe"] } == 1
    end

    sample("2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb_main.pl\tEnde LVS 048/5") do
      insist { subject["nachricht"] } == "Ende LVS 048/5"
      insist { subject["gewerk"] } == "DUEB"
      insist { subject["ereignis"] } == "Import Ende"
      insist { subject["lv_tag"] } == 48
      insist { subject["lv_scheibe"] } == 5
    end

    sample("2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb_main_batchbildung.pl\tSTART -c /opt/hdllv/config/hdllv.conf -t 049 -s 1") do
      insist { subject["nachricht"] } == "START -c /opt/hdllv/config/hdllv.conf -t 049 -s 1"
      insist { subject["gewerk"] } == "DUEB"
      insist { subject["ereignis"] } == "Batchbildung Start"
      insist { subject["lv_tag"] } == 49
      insist { subject["lv_scheibe"] } == 1
    end

    sample([
      "2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb_main_batchbildung.pl\tSTART -c /opt/hdllv/config/hdllv.conf -t 049 -s 1",
      "2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb_main_batchbildung.pl\tENDE"
    ]) do
      insist { subject[1]["nachricht"] } == "ENDE"
      insist { subject[1]["gewerk"] } == "DUEB"
      insist { subject[1]["ereignis"] } == "Batchbildung Ende"
      insist { subject[1]["lv_tag"] } == 49
      insist { subject[1]["lv_scheibe"] } == 1
    end

    sample("2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb_main_lo_anfrage.pl\tSTART -c /opt/hdllv/config/hdllv.conf -t 049 -s 1") do
      insist { subject["nachricht"] } == "START -c /opt/hdllv/config/hdllv.conf -t 049 -s 1"
      insist { subject["gewerk"] } == "DUEB"
      insist { subject["ereignis"] } == "LO-Anfrage Start"
      insist { subject["lv_tag"] } == 49
      insist { subject["lv_scheibe"] } == 1
    end

    sample("2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb_main_lo_anfrage.pl\tTelegramm LAG           00490001 empfangen") do
      insist { subject["nachricht"] } == "Telegramm LAG           00490001 empfangen"
      insist { subject["gewerk"] } == "DUEB"
      insist { subject["ereignis"] } == "LO-Antwort"
      insist { subject["lv_tag"] } == 49
      insist { subject["lv_scheibe"] } == 1
    end

    sample("2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb_main_lo_verarbeitung.pl\tSTART -c /opt/hdllv/config/hdllv.conf -t 049 -s 1") do
      insist { subject["nachricht"] } == "START -c /opt/hdllv/config/hdllv.conf -t 049 -s 1"
      insist { subject["gewerk"] } == "DUEB"
      insist { subject["ereignis"] } == "LO-Zuordnung Start"
      insist { subject["lv_tag"] } == 49
      insist { subject["lv_scheibe"] } == 1
    end

    sample("2016/01/29\t10:05:12\tddhpit01\t11773\thdllv\tdueb_main_nachbehandlung.pl\tSTART -c /opt/hdllv/config/hdllv.conf -t 049 -s 1") do
      insist { subject["nachricht"] } == "START -c /opt/hdllv/config/hdllv.conf -t 049 -s 1"
      insist { subject["gewerk"] } == "DUEB"
      insist { subject["ereignis"] } == "Nachbearbeitung Start"
      insist { subject["lv_tag"] } == 49
      insist { subject["lv_scheibe"] } == 1
    end

  end

end
