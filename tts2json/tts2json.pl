eval 'exec perl -w -S $0 ${1+"$@"}'
  if 0;

# ./tts2solr.pl ~/tts_sav/*.sav.???

use JSON::PP;
#use TELTYP_KR1;
use TELTYP_KR2;
my $line;

my $init_bof ="BOFxxxxyyyy01.01.7001:01:010001";
BOF_buf_to_tel_n( \$init_bof, \%bof );

while (<>) {
	chop;
	$line = $_;
	my %tel;

	# BOF
	BOF_buf_to_tel_n( \$line, \%bof ) if ( $line =~ /^BOF/ );

	# GW51
	TELTYP_KR2::GW1_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^GW1/ );
	
	# KA01/KA02
	TELTYP_KR2::KAS_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KAS/ );
	TELTYP_KR2::KAD_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KAD/ );
	TELTYP_KR2::KAE_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KAE/ );
	#TELTYP_KR2::KAL_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KAL/ );
	TELTYP_KR2::KWA_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KWA/ );
	
	# KA51
	TELTYP_KR2::KQ1_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KQ1/ );
	TELTYP_KR2::KQ2_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KQ2/ );
	
	# KU01
	TELTYP_KR1::KAU_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KAU/ );
	
	# KG01 
	KGZ_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KGZ/ );
	
	# KG51
	TELTYP_KR2::KGA_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KGA/ );
	KGF_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KGF/ );
	
	# KB51
	TELTYP_KR1::KB1_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KB1/ );
	
	# KU51
	KBK_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KBK/ );
	
	# LF02
	TELTYP_KR2::LF2_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^LF2/ );
							
	# WE20
	TELTYP_KR1::KEA_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KEA/ );
	TELTYP_KR1::KEQ_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KEQ/ );
	
	# WE70
	TELTYP_KR1::KED_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KED/ ); 
	TELTYP_KR1::KEE_buf_to_tel_n( \$line, \%tel ) if ( $line =~ /^KEE/ );	

	
	tel2json( $writer, \%tel, \%bof )if exists($tel{'TELTYP'});

	%tel = {};
	
}



##############################################################################
sub tel2json {
##############################################################################
  my ($writer, $tel, $bof) = @_;
  ${$tel}{'filetyp'} = ${$bof}{'filetyp'};
  ${$tel}{'verbindung'} = ${$bof}{'verbindung'};
  ${$tel}{'datum'} = ${$bof}{'datum'};
  ${$tel}{'zeit'} = ${$bof}{'zeit'};
  ${$tel}{'seq_nr'} = ${$bof}{'seq_nr'};

  my $json_text = JSON::PP->new->utf8->space_after->encode($tel);
  print $json_text,"\n";
	
	
}

###############################################################################
sub BOF_buf_to_tel_n {
###############################################################################
   my ($rbuf,$rtel) = @_;

# 0123456789012345678901234567890
# BOFKA01KRTR18.10.1015:17:140001
   ${$rtel}{'TELTYP'} = "BOF";
   ${$rtel}{'filetyp'} = substr(${$rbuf},3,4);
   ${$rtel}{'verbindung'} = substr(${$rbuf},7,4);
   ${$rtel}{'datum'} = substr(${$rbuf},11,8);
   ${$rtel}{'zeit'} = substr(${$rbuf},19,8);
   ${$rtel}{'seq_nr'} = substr(${$rbuf},27,4);
}

###############################################################################
sub KBK_buf_to_tel_n {
###############################################################################
   my ($rbuf,$rtel) = @_;

#          1         2         3         4         5         6         7         8         9         1    
#01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890   
#KBK974225        044000000I_0000000000000                                                  001damaged_tray 
   ${$rtel}{'TELTYP'} = "KBK";
   
   ${$rtel}{'art_nr'} = substr(${$rbuf},3,14);
   ${$rtel}{'art_gr'} = substr(${$rbuf},17,3);
   ${$rtel}{'lkz'} = substr(${$rbuf},20,6);
   ${$rtel}{'zoll_kz'} = substr(${$rbuf},26,1);
   ${$rtel}{'sperr_kz'} = substr(${$rbuf},27,1);
   ${$rtel}{'we_sendung'} = sprintf("%d",substr(${$rbuf},28,7));
   ${$rtel}{'wap_nr'} = sprintf("%d",substr(${$rbuf},35,6));
   # ${$rtel}{'upi'} = substr(${$rbuf},67,50);
   ${$rtel}{'menge'} = sprintf("%d",substr(${$rbuf},91,3));
   ${$rtel}{'status'} = substr(${$rbuf},94,16);
}

###############################################################################
sub KGZ_buf_to_tel_n {
###############################################################################
   my ($rbuf,$rtel) = @_;

# 0123456789012345678901234
# KGZN2104          038I_

   ${$rtel}{'TELTYP'} = "KGZ";
   ${$rtel}{'bs_flag'} = substr(${$rbuf},3,1);
   ${$rtel}{'art_nr'} = substr(${$rbuf},4,14);
   ${$rtel}{'art_gr'} = substr(${$rbuf},18,3);
   ${$rtel}{'zoll_kz'} = substr(${$rbuf},21,1);
   ${$rtel}{'sperr_kz'} = substr(${$rbuf},22,1);
   
}


#############################################################################
sub KGF_buf_to_tel_n {
#############################################################################
   my ($rbuf,$rtel) = @_;

   ${$rtel}{'TELTYP'} = "KGF";
   ${$rtel}{'lfd_tag'} = sprintf("%d",substr(${$rbuf},3,3));
   ${$rtel}{'lvs'} = sprintf("%d",substr(${$rbuf},6,1));
}
