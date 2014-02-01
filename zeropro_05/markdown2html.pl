use strict;
use warnings;

use Text::Markdown 'markdown';

my $file = 'callhistory_explain.txt';

open my $fh, '<', $file;
my @md = <$fh>;
close $fh;



use CGI ':standard';

print start_html(
			-lang => 'ja', 
		-encoding => 'utf-8', 
		-title => $file,
);
print markdown( join '', @md);
print end_html;