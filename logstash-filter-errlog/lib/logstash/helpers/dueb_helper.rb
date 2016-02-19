# encoding: UTF-8
#

class DuebHelper
  GEWERK = 'DUEB'

  def initialize
    @lv_tag = 0
    @lv_scheibe = 0
  end

  def parse(event)
    nachricht = event["nachricht"]
    programm = event["programm"]

    if nachricht =~ /^LVS\s(\d+)\/(\d+)\sbegonnen/
      event["gewerk"] = GEWERK
      event["ereignis"] = 'Datenuebertragung begonnen'
      event["lv_tag"] = $1.to_i
      event["lv_scheibe"] = $2.to_i
    end

    if nachricht =~ /^CLS-File.+Umbenennung nach dat7(\d\d\d)(\d)/
      event["gewerk"] = GEWERK
      event["ereignis"] = 'Daten von CLS eingetroffen'
      event["lv_tag"] = $1.to_i
      event["lv_scheibe"] = $2.to_i
    end

    if nachricht =~ /^Abruf.+LVS\s(\d+)\/(\d+)\sim Auftragspuffer gefunden/
      event["gewerk"] = GEWERK
      event["ereignis"] = 'Daten im Auftragspuffer gefunden'
      event["lv_tag"] = $1.to_i
      event["lv_scheibe"] = $2.to_i
    end

    if programm == "dueb_ftp.pl" &&
      nachricht =~ /^LVS\s(\d+)\/(\d+)\svollstaendig/
      event["gewerk"] = GEWERK
      event["ereignis"] = 'Daten fuer LV vollstaendig'
      event["lv_tag"] = $1.to_i
      event["lv_scheibe"] = $2.to_i
    end

    if programm == "dueb_main.pl" &&
      nachricht =~ /^Start Tag (\d+).+Scheibe (\d+)/
      event["gewerk"] = GEWERK
      event["ereignis"] = 'Import Start'
      event["lv_tag"] = $1.to_i
      event["lv_scheibe"] = $2.to_i
    end

    if programm == "dueb_main.pl" &&
      nachricht =~ /^Ende LVS (\d+)\/(\d+)/
      event["gewerk"] = GEWERK
      event["ereignis"] = 'Import Ende'
      event["lv_tag"] = $1.to_i
      event["lv_scheibe"] = $2.to_i
    end

    programm_liste = {
      "dueb_main_batchbildung.pl" => "Batchbildung", 
      "dueb_main_lo_anfrage.pl" => "LO-Anfrage",
      "dueb_main_lo_verarbeitung.pl" => "LO-Zuordnung",
      "dueb_main_nachbehandlung.pl" => "Nachbearbeitung",
      "dueb_main_convert.pl" => "Convert 3GL-Daten",
      "dueb_main_check.pl" => "Check",
      "dueb_db_del.pl" => "DB aufraeumen",
      "dueb_main_insert.pl" => "Insert"
    }

    if programm_liste.has_key?(programm)  &&
      nachricht =~ /^START.+-t (\d+) -s (\d+)/
      event["gewerk"] = GEWERK
      event["ereignis"] = programm_liste[programm] + ' Start'
      @lv_tag = event["lv_tag"] = $1.to_i
      @lv_scheibe = event["lv_scheibe"] = $2.to_i
    end

    if programm_liste.has_key?(programm) &&
      nachricht =~ /^ENDE/
      event["gewerk"] = GEWERK
      event["ereignis"] = programm_liste[programm] + ' Ende'
      event["lv_tag"] = @lv_tag
      event["lv_scheibe"] = @lv_scheibe
    end

    if nachricht =~ /^Telegramm LAG\s+(\d\d\d\d)(\d\d\d\d)/
      event["gewerk"] = GEWERK
      event["ereignis"] = 'LO-Antwort'
      event["lv_tag"] = $1.to_i
      event["lv_scheibe"] = $2.to_i
    end

    event["ereignis_code"] = event["ereignis"].downcase.gsub(/[^\w]/,'_') if event.include?("ereignis")

    event
  end
end
