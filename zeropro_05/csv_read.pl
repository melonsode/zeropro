use strict;
use warnings;
use Data::Dumper;

use GetCSV;

my $file = './csv/callhistory.csv';

my @data = GetCSV::get_data( $file );

my %numbers = ();

# 自社の電話番号の種類を抜き出す
for my $call (@data){
	if( $call->{IO} eq 'I' ){
		#print  $call->{sender}, "\n";
		my $num =  $call->{sender};
		$numbers{ $num }++;
	}
}

my @nums = keys %numbers;

my @num_count = ();
for my $n (@nums){
	my %hash = (
		number => $n,
		count => $numbers{ $n }
	);
	push @num_count, \%hash;
}

@num_count = sort { 
		$a->{number} cmp $b->{number}
} @num_count;

print Dumper(\@num_count);


__END__
use strict;
use warnings;

#my @array = (10, 6, 8, 1, 100, 50);
my @array = qw/fish apple cake jelly/;
			#("fish", "apple", "cake", "jelly";)


@array = sort { $b cmp $a } @array;

print "@array\n";

__END__
use strict;
use warnings;
use Data::Dumper;

use GetCSV;

my $file = './csv/callhistory.csv';

my @data = GetCSV::get_data( $file );

my %numbers = ();

# 自社の電話番号の種類を抜き出す
for my $call (@data){
	if( $call->{IO} eq 'I' ){
		#print  $call->{sender}, "\n";
		my $num =  $call->{sender};
		$numbers{ $num }++;
	}
}
#my @nums = keys %numbers;
#print "@nums\n";

print Dumper( \%numbers);

__END__
use strict;
use warnings;
use Data::Dumper;

use GetCSV;

my $file = './csv/callhistory.csv';

my @data = GetCSV::get_data( $file );

my %numbers = ();

# 自社の電話番号の種類を抜き出す
for my $call (@data){
	if( $call->{IO} eq 'O' ){
		#print  $call->{sender}, "\n";
		my $num =  $call->{sender};
		$numbers{ $num }++;
	}
}
#my @nums = keys %numbers;
#print "@nums\n";

print Dumper( \%numbers);


__END__
use strict;
use warnings;
use Data::Dumper;

use GetCSV;

my $file = './csv/callhistory.csv';

my @data = GetCSV::get_data( $file );

# 'receiver' => '0480801088',
# 'IO' => 'O',
# 'sender' => '',
# 'date' => '2013/07/31_19:50-28',
# 'device' => '39'

print "All calls: ".scalar @data."\n";
my $sum_in = 0;
my $sum_out = 0;



$call->{sender}

for my $call (@data){
	if( $call->{IO} eq 'I' ){
		#$sum_in = $sum_in + 1;
		$sum_in += 1;
	}elsif($call->{IO} eq 'O' ){
		$sum_out++;
	}
	#print $call->{sender}, "\n";
}

print "Sum of Inboud calls: $sum_in\n";
print "Sum of Outboud calls: $sum_out\n";
print "Sum of in and out: ".($sum_in + $sum_out)."\n";
















__END__
use strict;
use warnings;

get_data();


sub get_data{

	my $file = './csv/callhistory.csv';
	#open関数
	#       ファイルハンドル, 
	#		読み書きの形式 <:読 >:書
	#　　　　ファイル名
	open my $fh, '<', $file;
	my @csv = <$fh>;
	close $fh;

	#IO date device sender receiver

	#for(my $i = 0; $i < @csv; $i)

	my @data = ();

	for my $call (@csv){
		chomp $call;
		my @elem = split(',', $call);
		my %hash = (
			IO => $elem[0],
			date => $elem[1],
			device => $elem[2],
			sender => $elem[3],
			receiver => $elem[4],
		);
		push @data, \%hash;
	}

	use Data::Dumper;
	print Dumper( \@data );#リファレンス化


	#print $data[11]{receiver}, "\n";
}



__END__



use strict;
use warnings;


my $file = './csv/callhistory.csv';
#open関数
#       ファイルハンドル, 
#		読み書きの形式 <:読 >:書
#　　　　ファイル名
open my $fh, '<', $file;
my @csv = <$fh>;
close $fh;



#for(my $i = 0; $i < @csv; $i)
for my $call (@csv){
	chomp $call;
	my @elem = split(',', $call);
	print $elem[1], "\n";
}











__END__
if( -e 'callhistory.csv'){
	print "OK!\n";
}else{
	print "NO!\n";
}


__END__


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

