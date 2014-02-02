package GetCSV;


sub get_data{
	my ($file) = @_;

	open my $fh, '<', $file;
	my @csv = <$fh>;
	close $fh;

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

	#use Data::Dumper;
	#print Dumper( \@data );#リファレンス化

	return @data;
	#print $data[11]{receiver}, "\n";
}


1;