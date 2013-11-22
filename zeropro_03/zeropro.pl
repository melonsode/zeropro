use strict;

my $file = 'callhistory.csv';

my $fh;

open $fh, '<', $file or die $!;
my @csv = <$fh>;
close $fh;

my $i = 0;
my $o = 0;
for(@csv){
	$i++ if $_ =~ /^I/;
	$o++ if $_ =~ /^O/;
}

print scalar( @csv ),"\n";
print "Inboud $i\n";
print "Outboud $o\n";
























__END__

my %era_year = (
					'Meiji' => 1868,
					'Taisyo' => 1912,
					'Syowa' => 1926,
					'Heisei' => 1989,
				 );

for my $y (1868..2013){
	my $era_name = 'Unknown';
	if( $y < $era_year{'Taisyo'} ){
		&calc_year( 'Meiji', $y );
	}elsif( $y < $era_year{'Syowa'} ){
		&calc_year( 'Taisyo', $y );
	}elsif( $y < $era_year{'Heisei'} ){
		&calc_year( 'Syowa', $y );
	}else{
		&calc_year( 'Heisei', $y );
	}
}

sub calc_year{
	my ( $era_name, $y ) = @_;
	my $era_y = $y - $era_year{ $era_name } + 1;
	print $y, "年 =:::";
	print $era_name, ': ', $era_y, "年\n";
}





__END__

























for my $y (1868..2013){
	if($y < $era_year{'Taisyo'}){
		print "$y年 = 明治 ".($y - $era_year{'Meiji'} + 1) ."年\n";
	}elsif($y < $era_year{'Syowa'}){
		print "$y年 = 大正 ".($y - $era_year{'Taisyo'} + 1) ."年\n";
	}elsif($y < $era_year{'Heisei'}){
		print "$y年 = 昭和 ".($y - $era_year{'Syowa'} + 1) ."年\n";
	}else{
		print "$y年 = 平成 ".($y - $era_year{'Heisei'} + 1) ."年\n";
	}
}








__END__
use strict;
#use warnings;

#宣言 これから使います
my %era_year = (
					'Heisei' => 1989,
					'Syowa' => 1926,
					'Taisyo' => 1912,
					'Meiji' => 1868
				 );

#$era_year{'Taisyo'} #1982

my @era = keys %era_year;

for my $jidai (@era){
	print "$jidai は $era_year{$jidai} にはじまります。\n";
}

#ToDo
#Heiseiは .. 年にはじまります
#Showaは .. 年にはじまります
#Taisyoは .. 年にはじまります
# ...
#









#print 'Heiseiは', $era_year{'Heisei'}, '年にはじまります。', "\n";

#ヒント for文と下記を組み合わせ
@era = keys %era_year;


#ToDo
#Heiseiは .. 年にはじまります
#Showaは .. 年にはじまります
#Taisyoは .. 年にはじまります
# ...
#










__END__
#@years = (1..2013);

#↓参考
for $y ( 1970..2013 ){
	if( $y < 1989){
		print "$y : Syowa Umare!\n";
	}elsif( $y == 1989){
		print "$y : Syowa or Heisei Umare!\n";
	}else{
		print "$y : Heisei Umare!\n";
	}
}


# Heisei 1989
# syowa 1926
# Taisyo 1912
# Meiji 1868

#結果
# 1970 syowa
# 1971 syowa
# 1972 syowa
#....
# 2011 heisei
# 2012 heisei
# 2013 heisei





__END__








__END__
#@eras = ('明治', '大正', '昭和', '平成');

@eras = qw/慶応 明治 大正 昭和 平成/;

#1989

print 'Born year:';

$b_year = <STDIN>;

chomp( $b_year);

if( $b_year < 1989 ){
	print "Showa!\n";
}elsif($b_year == 1989){
	print "Show or Heisei!\n";
}else{
	print "Heisei!\n";
}











__END__
for $jidai ( @eras ){
	print $jidai, "\n";
}


# C言語ライクな書き方
#   はじめ  おわり　１ステップ進んだら
for($i = 0; $i <= $#eras ; $i++ ){
	print $eras[$i], "\n";
}


#print $eras[0], "\n";
#print $eras[1], "\n";
#print $eras[2], "\n";
#print $eras[3], "\n";






__END__
#$string = q/I'm living in Koshigaya/;
$string = qq/I'm living in "Koshigaya"/;

print $string,"\n";


#print '$eras[3] \n';

#print "$eras[3] \n";

#print $eras[3]."\n";



