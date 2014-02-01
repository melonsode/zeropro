

# 5.47G

use strict;
use warnings;

use Text::CSV;
use Data::Dumper::Concise;
use Time::Piece;

my $parser = Text::CSV->new();


my $csv = 'callhistory_small.csv';

my $data = get_data( $csv );

print Dumper($data);

sub get_data{
	my ($file) = @_;

	open my $fh, '<', $csv or die "Can't open:$csv";

	my @attr = qw/IO date device sender receiver/;
	my @calls = ();
	
	while( my $row = <$fh>){
		chomp $row;
		my @array = split(',', $row);
		my $t = Time::Piece->strptime($array[1], "%Y/%m/%d_%H:%M-%S");
		my %hash = (
			IO => $array[0],
			dateraw =>  $array[1],
			date => $t->ymd,
			time => $t->hms,
			device =>  $array[2],
			sender =>  $array[3],
			reciever =>  $array[4]
		);
		push @calls, \%hash;
	}

	close $fh;

	return \@calls;
	#print Dumper(\@calls);

}


__END__
use strict;
use warnings;

use Text::CSV;
use Data::Dumper::Concise;


my $parser = Text::CSV->new();


my $csv = 'callhistory.csv';
open my $fh, '<', $csv or die "Can't open:$csv";

my @attr = qw/IO date device sender receiver/;
my @calls = ();

#http://d.hatena.ne.jp/perlcodesample/20091105/1246274997
use Time::Piece;


while( my $row = <$fh>){
	chomp $row;
	my @array = split(',', $row);
	my $t = Time::Piece->strptime($array[1], "%Y/%m/%d_%H:%M-%S");
	my %hash = (
		IO => $array[0],
		dateraw =>  $array[1],
		date => $t->ymd,
		time => $t->hms,
		device =>  $array[2],
		sender =>  $array[3],
		reciever =>  $array[4]
	);
	push @calls, \%hash;
}

close $fh;


print Dumper(\@calls);


__END__

	my $csv_file = shift;

	if(! -e $csv_file ){
		return [];
	}
 	my $csv = Text::CSV->new ( { binary => 1 } )  # should set binary attribute.
                 or die "Cannot use CSV: ".Text::CSV->error_diag ();

 	my @rows;
	 open my $fh, "<:encoding(utf8)", $csv_file or die "$csv_file : $!";
	 while ( my $row = $csv->getline( $fh ) ) {
	     #$row->[2] =~ m/pattern/ or next; # 3rd field should match
	     push @rows, $row;
	 }
	 $csv->eof or $csv->error_diag();
	 close $fh;

	 return \@rows;




__END__


# csvを読み込んで構造化する

# サブルーチンを使う

# リファレンス、デリファレンスの練習

# 少しモジュールを使ってみる

 - Data::Dumper | Data::Dumper::Concise;
 - Time::Piece
 - Text::CSV


__END__
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

