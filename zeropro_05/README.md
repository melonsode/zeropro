# 第五回 講義資料

資料はまだ整理しておらず、混沌としております。  

## 参加者

 - 全参加者: 12名
 - 補講参加者: 12名
 - 懇親会参加者: 10名


## 講義ノート

（関口くんが書いてくれた講義ノートです）

### ファイルのopen

#### ファイルの存在確認

callhistory.csvを同じディレクトリに置く。
csv_read.plを作成

	use strict;
	use warnings;
	
	if( -e 'callhistory.csv'){
		print "OK!\n";
	}else{
		print "No!\n"; 
	}

これで、OK!と表示されるか確認。

 e　はファイルがあるかどうか確認。
 
 #### open関数
 
 次がopenする。以下の様に書き換え
 
	use strict;
	use warnings;
	
	my $file = 'callhistory.csv';
	open my $fh, '<', $file;
	
	close $fh;

以下のように書いても良いが、可読性が下がるので上記のように書いた。
	
	open my $fh, '<', 'callhistory.csv';
	
	close $fh;
	
open関数には3つの引数がある。

1. ファイルハンドル
2. 読み書きの形式 < は読み込み、　>　は書き込み
3. ファイル名

---
ファイルすべてを読み込んで @csv　という配列に格納する。

	use strict;
	use warnings;
	my $file = 'callhistory.csv';
	
	open my $fh, '<', $file;
	my @csv = <$fh>;
	close $fh;
	print "@csv\n";

これでファイル内のデータがすべて表示される。

for文を使って全部表示する場合は以下のよう。

	use strict;
	use warnings;
	
	my $file = 'callhistory.csv';
	
	open my $fh, '<', $file;
	my @csv = <$fh>;
	close $fh;
	
	for my $call (@csv){
		print $call;
	}
	
#### 変数のスコープの違いに注意

ちなみに、for文を以下のようにすると表示されない。これはスコープの関係。
	
	for my $call (@csv){

	}
		print $call;

#### 行末の改行を削る：chomp関数

chompを使って、改行を消す。

	for my $call (@csv){
		chomp $call;
		print $call;
	}

#### 特定の文字で区切って配列に格納：split関数

csvはカンマで区切られているので、splitを使って、カンマで切り取る。こうすると日付だけ表示出来る。

	for my $call (@csv){
		chomp $call;
		my @elem = split(',', $call);
		print $elem[1], "\n";
	}

### データの構造化

以下の様にfor文にhashを作成し、csvファイルを構造化する。
Data::Dumperはモジュールの名前。

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
	use Data::Dumper;
	print Dumper( \%hash);
	}


今のコードをすべて書くと以下のようになる。
	
	use strict;
	use warnings;
	
	my $file = 'callhistory.csv';
	
	open my $fh, '<', $file;
	my @csv = <$fh>;
	close $fh;
	
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
		use Data::Dumper;
		print Dumper( \%hash); #リファレンス化
	}

\%hash　はhashのリファレンス

配列に値を入れるのはpushという関数を使う。

	use strict;
	use warnings;
	
	my $file = 'callhistory.csv';
	
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

	use Data::Dumper;
	print Dumper( \@data); #リファレンス化

%hashはデカくて渡せないので、リファレンス化して \$hash として渡す。

このように構造化しておくと、簡単にデータにアクセスできる。
以下のように書いて、アクセスする。

	use strict;
	use warnings;
	
	my $file = 'callhistory.csv';
	
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
	
	print $data[10]{receiver}, "\n";
	
### サブルーチンを作る

サブルーチンを作る。外部化。本体とは切り離された部分。
サブルーチンは他の言語では関数（function）やメソッドなどと呼ばれる。


	use strict;
	use warnings;

	sub get_data{
		my $file = 'callhistory.csv';
	
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
			use Data::Dumper;
			print Dumper( \@data); #リファレンス化	
	}

これを実行しても、何も表示されない。本体部分でget_dataを呼び出す必要がある。

以下のようにすると、今までのように構造化したデータを表示出来る。

	use strict;
	use warnings;

	get_data();

	sub get_data{
		my $file = 'callhistory.csv';
	
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
			use Data::Dumper;
			print Dumper( \@data); #リファレンス化
	}

---

関数は入れるものと出てくるものがある。入れるものは引数(ひきすう, argument)と呼ぶ。

    （入力）→[関数]→（出力）

#### 関数への入力：引数

$fileを引数としてサブルーチンに与える。
引数の受け取りは、「 @_ 」 で受け取れる。


	use strict;
	use warnings;
	
	my $file = 'callhistory.csv';
	
	get_data( $file );
	
	sub get_data{
		my ($file) = @_;
		
		# my $file = @_; だと配列の個数が返ってきてしまう

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

		use Data::Dumper;
		print Dumper( \@data); #リファレンス化
	}

my ($file) = @_;　をshiftを使って書くことも出来る。

	my $file = shift @_;
	

#### 関数の出力（戻り値）：return

入力があったら、出力も欲しい。出力には構造化したデータを返す。

	use strict;
	use warnings;
	use Data::Dumper;
	
	my $file = 'callhistory.csv';
	
	my @data = get_data( $file );
	
	print Dumper(\@data);
	
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
		return @data;
	}

参考

	sub get_data{
		my ($file) = @_;
		#なんとかかんとか
		return @data;
	}

### Perlモジュール（.pm）の作り方

サブルーチンが沢山になってきたら、サブルーチンだけのモジュールを作って
外部ファイル化したりできる。

同じディレクトリ内に GetCSV.pm を作成。内容は以下。
pmのファイル名とpackageにかくモジュール名は一致させる。
最後に 1; を書くのを忘れない。（Perlの残念なところ）

	package GetCSV;







	1;

csv_read.plにモジュール名を書き足す

	use strict;
	use warnings;
	use Data::Dumper;
	use GetCSV; # new!

モジュール内に、subを書き足す

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
	
			# use Data::Dumper;
			# print Dumper( \@data); #リファレンス化
	
			return @data;
	}

	1;

これだけだと実行出来ないので、本体のmy @dataの部分を書き換え。

	my @data = GetCSV::get_data( $file );

### 構造化したデータを操作する

入電数を数える。

	use strict;
	use warnings;
	use Data::Dumper;
	
	use GetCSV;
	
	my $file = 'callhistory.csv';
	
	my @data = GetCSV::get_data( $file );
	
	
	
	my $sum_in = 0;
	
	for my $call (@data){
		if( $call->{IO} eq 'I' ){
			$sum_in = $sum_in + 1;
		}
	}
	
	print "Sum of Inbound calls: $sum_in\n";
	
答えは、1119

架電数も数えて、入電数との合計(=データ数)を出してみる。

	use strict;
	use warnings;
	use Data::Dumper;
	
	use GetCSV;
	
	my $file = 'callhistory.csv';
	
	my @data = GetCSV::get_data( $file );
	
	
	print "All calls: ".scalar @data."\n";
	
	my $sum_in = 0;
	my $sum_out = 0;
	
	for my $call (@data){
		if( $call->{IO} eq 'I' ){
			$sum_in = $sum_in + 1;
		}elsif($call->{IO} eq 'O'){
			$sum_out++;
			# $sum_out += 1;
			# $sum_in = $sum_in + 1;
			# と同じ意味。
		} 
	}
	
	print "Sum of Inbound calls: $sum_in\n";
	print "Sum of Outbound calls: $sum_out\n";
	print "Sum of in and out: ".($sum_in + $sum_out)."\n";
	
以下の様に表示される。

	All calls: 1964
	Sum of Inbound calls: 1119
	Sum of Outbound calls: 845
	Sum of in and out: 1964

---

リファレンス(参照) ←→ デリファレンス(実体)

---

発信者の電話番号の種類を表示する。

	use strict;
	use warnings;
	use Data::Dumper;
	
	use GetCSV;
	
	my $file = 'callhistory.csv';
	
	my @data = GetCSV::get_data( $file );
	
	my %numbers = ();
	
	for my $call (@data){
		if( $call->{IO} eq 'O' ){
			# print $call->{sender}, "\n";
			my $num = $call->{sender};
			$numbers{ $num } = 1;
		}
	}
	my @nums = keys %numbers;
	print "@nums\n";

---

	use strict;
	use warnings;
	use Data::Dumper;
	
	use GetCSV;
	
	my $file = 'callhistory.csv';
	
	my @data = GetCSV::get_data( $file );
	
	my %numbers = ();
	
	for my $call (@data){
		if( $call->{IO} eq 'O' ){
			# print $call->{sender}, "\n";
			my $num = $call->{sender};
			$numbers{ $num }++
		}
	}
	
	print Dumper( \%numbers );

---

sort: 配列を並び替える

	use strict;
	use warnings;
	
	my @array = (10, 6, 8, 100, 15);
	
	@array = sort { $a <=> $b} @array;
	# $a　は特殊な演算子。数字しか使えない。小さい順に並べる。
	# { $a <=> $b}  にすると大きい順になる。
	
	print "@array\n";


着信数順に並び替える

	use strict;
	use warnings;
	use Data::Dumper;
	
	use GetCSV;
	
	my $file = 'callhistory.csv';
	
	my @data = GetCSV::get_data( $file );
	
	my %numbers = ();
	
	for my $call (@data){
		if( $call->{IO} eq 'I' ){
			# print $call->{sender}, "\n";
			my $num = $call->{sender};
			$numbers{ $num }++
		}
	}
	my @nums = keys %numbers;
	
	my @num_count = ();
	for my $n (@nums){
		my %hash = (
			number => $n,
			count => $numbers{$n}
		);
		push @num_count, \%hash;
	}
	
	print Dumper(\@num_count);
	
	@num_count = sort {
			$b->{count} <=> $a->{count}
		} @num_count;
	
	print Dumper(\@num_count);
