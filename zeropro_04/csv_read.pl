use strict;
use warnings;
use Data::Dumper;

my $csv = 'callhistory.csv';

open my $fh, '<', $csv or die "$csv: $!";
my @lines = <$fh>;
close $fh;

my @data = ();
for my $line ( @lines ){
	chomp $line;
	my @elem = split(',', $line);

	#my @param = ('IO', 'date', 'device', 'sender', 'responder');
	#				0  1    2      3       4
	my @param = qw/IO date device sender responder/;

	my %record = ();
	for(my $i = 0; $i < scalar @param; $i++){
		#print $param[$i], ' : ' ,$elem[$i], "\n";
		$record{ $param[$i] } = $elem[$i];
	}
	push @data, \%record; # ハッシュのリファレンス
}

#print Dumper( \@data );
print $data[90]->{date},"\n"; 










__END__
#keys とfor分を使って　%record を出力

my @keyword = keys %record;
for my $k (@keyword){
	print " $k : $record{ $k } \n";
}






__END__
my $in = 0;
my $out = 0;
for my $line (@lines){
	#print $line;
	if( $line =~ /^I/ ){
		#print $line if $line !~ /^O/;
		$in += 1;
	}elsif( $line =~ /^O/ ){
		$out += 1;
	}
}

print "Inbound: $in, Outbound: $out\n";

__END__
my $all = $in + $out;
print "All: " . $all . "\n";
print "ratio of inbound: " . $in /( $in + $out) * 100 . "% \n";

__END__
my $count = scalar @lines ;
print "all tel: $count \n";




__END__

if( -e $csv ){
	print "csv OK\n";
}else{
	print "csv NO\n";
}

