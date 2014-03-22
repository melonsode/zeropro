###準備
[GitHubのzeropro/zeropro_06](https://github.com/melonsode/zeropro)からファイルをダウンロード

---

##文字コードの扱い
新規ファイル作成を作成

	#encode.pl
	
	use strict;
	use warnings;
	
	my $txt = 'string_shiftjis.txt';
	
	open my $fh, '<', $txt
			or die "Can't open $txt";
	
	while(my $line = <$fh>){
		chomp $line;
		print $line, "\n";
	}
	
	close $fh;

これだと、文字化けして結果が
		
	shiftjis
	??????????

になる。結果は実行環境によって異なる。

---
文字化けさせないためには、decodeする必要がある。

	use strict;
	use warnings;
	
	my $txt = 'string_shiftjis.txt';
	
	open my $fh, '<:encoding(shiftjis)', $txt
			or die "Can't open $txt";
	
	while(my $line = <$fh>){
		chomp $line;
		print $line, "\n";
	}
	
	close $fh;

これで、文字化けせずに出る。

	shiftjis
	Wide character in print at encode.pl line 11, <$fh> line2.
	あいうえお

文字化けはしないが、warningが出る。encodeする必要がある。

	use strict;
	use warnings;
	
	use Encode 'encode';
	
	my $txt = 'string_shiftjis.txt';
	
	open my $fh, '<:encoding(shiftjis)', $txt
			or die "Can't open $txt";
	
	while(my $line = <$fh>){
		chomp $line;
		print $line, "\n";
	}
	
	close $fh;

useするだけで使えるモジュールもあるが、中には「モジュールのどの関数を使うか」を指定しないといけないものもある。

今回使う Encode　は指定しないといけない。
	
	#例

	use Encode 'encode', 'decode', 'encode_utf8', 'decode_utf8';
	
	use Encode qw/encode decode encode_utf8 decode_utf8/;
	
	#1行目と2行目は同じ意味
	

次のように書き換えると
	
	use strict;
	use warnings;
	
	use Encode 'encode';
	
	my $txt = 'string_shiftjis.txt';
	
	open my $fh, '<:encoding(shiftjis)', $txt
			or die "Can't open $txt";
	
	while(my $line = <$fh>){
		chomp $line;
		print encode('utf-8',$line), "\n";
	}
	
	close $fh;
	
warningが出ないようになる。
	
	#実行結果
		
	shiftjis
	あいうえお
---
読み込んだ関数をdecodeするようにする。

	use strict;
	use warnings;
	
	use Encode 'encode';
	
	my $txt = 'string_shiftjis.txt';
	
	open my $fh, '<:encoding(shiftjis)', $txt
			or die "Can't open $txt";
	
	while(my $line = <$fh>){
		chomp $line;
		$line = decode('shiftjis', $line);
		print encode('utf-8', $line), "\n";
	
	}
	
	close $fh;
---

全部出力をutf-8にしたい時は以下の様な書き方もある。

	use strict;
	use warnings;
	
	use Encode 'encode', 'decode';
	
	
	binmode STDOUT, ':encoding(utf-8)';
	
	my $txt = 'string_shiftjis.txt';
	
	open my $fh, '<', $txt
			or die "Can't open $txt";
	
	while(my $line = <$fh>){
		chomp $line;
		$line = decode('shiftjis', $line);
		print $line, "\n";
	
	}
	
	close $fh;
---
他のファイルも読み込んでみる
	
	use strict;
	use warnings;
	
	use Encode 'encode';
	
	my $txt = 'string_eucjp.txt';
	
	open my $fh, '<:encoding(euc-jp)', $txt
			or die "Can't open $txt";
	
	while(my $line = <$fh>){
		chomp $line;
		print encode('utf-8', $line), "\n";
	
	}
	
	close $fh;
	
###正規表現
「あいうえお」の「あ」を「か」に書き換える

	use strict;
	use warnings;
	
	use Encode 'encode';
	
	
	my $txt = 'string_shiftjis.txt';
	
	open my $fh, '<:encoding(shiftjis)', $txt
			or die "Can't open $txt";
	
	while(my $line = <$fh>){
		chomp $line;
		$line =~ s/あ/か/;
		print encode('utf-8', $line), "\n";
	}
	
	close $fh;

これでは、書き換えができない。なぜなら、Perlの内部コードになっていないから。

書き換える方法は2種類。

* 1:　それぞれdecodeする

```
use strict;
use warnings;	
use Encode 'encode', 'decode';
my $txt = 'string_shiftjis.txt';

open my $fh, '<:encoding(shiftjis)', $txt
		or die "Can't open $txt";

while(my $line = <$fh>){
	chomp $line;
	my $a = decode('utf-8', 'あ');
	my $ka = decode('utf-8', 'か');
	$line =~ s/$a/$ka/;
	print encode('utf-8', $line), "\n";
}

close $fh;

```

* 2:　utf8プラグマを使う

```
use strict;
use warnings;

use utf8;
use Encode 'encode', 'decode';

my $txt = 'string_shiftjis.txt';

open my $fh, '<:encoding(shiftjis)', $txt
		or die "Can't open $txt";

while(my $line = <$fh>){
	chomp $line;
	$line =~ s/あ/か/;
	print encode('utf-8', $line), "\n";
}

close $fh;
```

---

###オブジェクト指向
callhistory_small.csvの中身を表示する。(前回の内容)

	use strict;
	use warnings;
	
	my $data = get_data('callhistory_small.csv');
	
	use Data::Dumper;
	
	print Dumper($data);
	
	sub get_data{
		my $input = shift @_;
		
		my @data = ();
		open my $fh, '<', $input or die "Can't open $input\n";
		while(my $line = <$fh>){
			chomp $line;
			push @data, [ split(',', $line) ];
		}
		close $fh;
		return \@data;
	}


splitの部分に関して。

```	
[ split(',', $line) ];

```
以下の２つと同じ意味

```
my @elem = split(',', $line);
	push @data, [ @elem ];
```	
```	
my @elem = split(',', $line);
	push @data, \@elem;
```
---
新規ファイル作成。ファイル名：Call.pm

	#Call.pm
	
	package Call;



	1;

メインのスクリプトを以下のように変更。ファイル名：zeropro.pl
	
	#zeropro.pl
	
	use strict;
	use warnings;
	
	use Call;
	
	my $data = get_data('callhistory_small.csv');
	
	
	my $c = Call->new($data->[0]);
	
	$c->dump();
	
	
	
	sub get_data{
		my $input = shift @_;
		
		my @data = ();
		open my $fh, '<', $input or die "Can't open $input\n";
		while(my $line = <$fh>){
			chomp $line;
			my @elem = split(',', $line);
			push @data, [ @elem ];
		}
		close $fh;
		return \@data;
	}
	

Call.pmを編集
	
	#Call.pm
	
	package Call;

	sub new{
		my ($package, $arg) = @_;
		my $self = { data => $arg };

		return bless $self, $package;
	}

	sub dump{
		my $self = shift;
		print @{$self->{data}}, "\n";
	}

	1;

```
my $self = shift;
は
my $self = shift @_;　の略
```

編集

	#zeropro.pl
	
	use strict;
	use warnings;
	
	use Call;
	
	my $data = get_data('callhistory_small.csv');
	
	
	my $c = Call->new($data->[0]);
	
	$c->dump();
	
	
	if( $c->isInbound() ){
		print "IN\n";
	}else{
		print "OUT\n";
	}
	
	
	sub get_data{
		my $input = shift @_;
		
		my @data = ();
		open my $fh, '<', $input or die "Can't open $input\n";
		while(my $line = <$fh>){
			chomp $line;
			my @elem = split(',', $line);
			push @data, [ @elem ];
		}
		close $fh;
		return \@data;
	}

Call.pmも編集

	#Call.pm
	
	package Call;
	
	sub new{
		my ($package, $arg) = @_;
		my $self = { data => $arg };
	
		return bless $self, $package;
	}
	
	sub dump{
		my $self = shift @_;
		print @{$self->{data}}, "\n";
	}
	
	sub isInbound{
		my $self = shift @_;
		if($self->{data}[0] eq 'I'){
			return 1;
		}else{
			return 0;
		}
	}
	
	
	1;
	
日付も表示するように書き換え

```
#zeropro.pl

use strict;
use warnings;

use Call;

my $data = get_data('callhistory_small.csv');


my $c = Call->new($data->[0]);

$c->dump();


if( $c->isInbound() ){
	print "IN\n";
}else{
	print "OUT\n";
}

$c->when();


sub get_data{
	my $input = shift @_;
	
	my @data = ();
	open my $fh, '<', $input or die "Can't open $input\n";
	while(my $line = <$fh>){
		chomp $line;
		my @elem = split(',', $line);
		push @data, [ @elem ];
	}
	close $fh;
	return \@data;
}
```

```
#Call.pm

package Call;

sub new{
	my ($package, $arg) = @_;
	my $self = { data => $arg };

	return bless $self, $package;
}

sub dump{
	my $self = shift @_;
	print @{$self->{data}}, "\n";
}

sub isInbound{
	my $self = shift @_;
	if($self->{data}[0] eq 'I'){
		return 1;
	}else{
		return 0;
	}
}

sub when{
	my $self = shift @_;
	print $self->{data}[1], "\n";
}


1;


```
	
	#zeropro.pl
	
	$c->when();

とする場合は、

	#Call.pm
	return $self->{data}[1], "\n";
 
 とする必要がある。
 
---

オブジェクト指向の場合はデータに触らないほうが良いとされている。それを「カプセル化」と言う。


```
#zeropro.pl

use strict;
use warnings;

use Call;

my $data = get_data('callhistory_small.csv');


my $c = Call->new($data->[0]);

$c->dump();


if( $c->isInbound() ){
	print "IN\n";
}else{
	print "OUT\n";
}

$c->when;
print $c->time, "\n";



sub get_data{
	my $input = shift @_;
	
	my @data = ();
	open my $fh, '<', $input or die "Can't open $input\n";
	while(my $line = <$fh>){
		chomp $line;
		my @elem = split(',', $line);
		push @data, [ @elem ];
	}
	close $fh;
	return \@data;
}
```

```
#Call.pm

package Call;

sub new{
	my ($package, $arg) = @_;
	my $self = { data => $arg };

	return bless $self, $package;
}

sub dump{
	my $self = shift @_;
	print @{$self->{data}}, "\n";
}

sub isInbound{
	my $self = shift @_;
	if($self->{data}[0] eq 'I'){
		return 1;
	}else{
		return 0;
	}
}

sub when{
	my $self = shift @_;
	print $self->{data}[1], "\n";
}

sub time{
	my $self = shift @_;
	return $self->{data}[1];
}

1;

```
###YouTubeからデータを取得

	use strict;
	use warnings;
	
	use LWP::UserAgent;
	
	my $ua = LWP::UserAgent->new();
	
	my $url = 'http://gdata.youtube.com/feeds/api/videos?q=越谷';
	
	my $res = $ua->get($url);
	
	print $res->content;
