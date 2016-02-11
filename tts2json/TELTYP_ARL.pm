package TELTYP_ARL;

# use strict;

#############################################################
#  Telegramm KEA                                            #
#############################################################

sub KEA_buf_to_tel_n {
   my ($rbuf,$rtel) = @_;

   ${$rtel}{'TELTYP'} = "KEA";
   ${$rtel}{'wannen_id_12'} = substr(${$rbuf},3,12);
}

#############################################################
#  Telegramm KED                                            #
#############################################################



sub KED_buf_to_tel_n {
   my ($rbuf,$rtel) = @_;

   ${$rtel}{'TELTYP'} = "KED";
   ${$rtel}{'wannen_id_12'} = substr(${$rbuf},3,12);
   ${$rtel}{'artnr'} = substr(${$rbuf},15,14);
   ${$rtel}{'grs'} = sprintf("%d",substr(${$rbuf},29,3));
   ${$rtel}{'lkz'} = sprintf("%d",substr(${$rbuf},32,6));
   ${$rtel}{'zoll_kz'} = substr(${$rbuf},38,1);
   ${$rtel}{'sperr_kz'} = substr(${$rbuf},39,1);
   ${$rtel}{'we_sendung'} = sprintf("%d",substr(${$rbuf},40,7));
   ${$rtel}{'wap'} = sprintf("%d",substr(${$rbuf},47,6));
   ${$rtel}{'bezeichnung'} = substr(${$rbuf},53,18);
   ${$rtel}{'farbe'} = substr(${$rbuf},71,12);
   ${$rtel}{'laenge'} = sprintf("%d",substr(${$rbuf},83,6));
   ${$rtel}{'breite'} = sprintf("%d",substr(${$rbuf},89,6));
   ${$rtel}{'hoehe'} = sprintf("%d",substr(${$rbuf},95,6));
   ${$rtel}{'volumen'} = sprintf("%d",substr(${$rbuf},101,6));
   ${$rtel}{'gewicht'} = sprintf("%d",substr(${$rbuf},107,6));
   ${$rtel}{'upi'} = substr(${$rbuf},113,50);
   ${$rtel}{'ean1'} = substr(${$rbuf},163,13);
   ${$rtel}{'ean2'} = substr(${$rbuf},176,13);
   ${$rtel}{'ean3'} = substr(${$rbuf},189,13);
   ${$rtel}{'ean4'} = substr(${$rbuf},202,13);
   ${$rtel}{'ean5'} = substr(${$rbuf},215,13);
   ${$rtel}{'ean6'} = substr(${$rbuf},228,13);
}

#############################################################
#  Telegramm KEE                                            #
#############################################################



sub KEE_buf_to_tel_n {
   my ($rbuf,$rtel) = @_;

   ${$rtel}{'TELTYP'} = "KEE";
   ${$rtel}{'wannen_id_12'} = substr(${$rbuf},3,12);
   ${$rtel}{'status'} = substr(${$rbuf},15,1);
}


1;