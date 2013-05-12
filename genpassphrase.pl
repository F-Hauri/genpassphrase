#!/usr/bin/perl -w
# produce random passphrase from dictionnary, using /dev/random.
# Copyright (C) 2013 Félix Hauri - www.F-Hauri.ch - passphrase.pl@f-hauri.ch
# This program is covered by the GNU General Public License version 3: GPLv3
# http://www.gnu.org/licenses/gpl-3.0.html
use vars qw(%VERSION $DEBUG $IO_CONSTANTS);
($VERSION{"name"},$VERSION{"number"},$VERSION{"date"},$VERSION{"user"})=
  ($1,$2,$3,$4) if '$Id: passphrase.pl,v 1.3 2013-05-12 10:43:14 felix Exp $ ' =~
    /Id:\s(.+),v\s([0-9a-z.-]+)\s([0-9\/-]+\s[0-9:]+)\s([a-z0-9_-]+)\sExp/;#CV

use strict;
use Getopt::Std;
my %opt;
getopt('dairlew',\%opt );

my $dict="/usr/share/dict/american-english";
my ($minLen,$maxLen)=(4,11);
my $rndDev="/dev/urandom";

my $numLines=1;
my $bitIdx=15;
my $wrdByLines=5;

(my $progname=$0) =~ s/^.*[\/]//g;

$numLines=$1 if $ARGV[0] && $ARGV[0]=~/^(\d+)$/;

$dict       = $opt{'d'} if $opt{'d'} && -r $opt{'d'};
$rndDev     = $opt{'r'} if $opt{'r'} && -r $opt{'r'};
$minLen     = $1 if $opt{'i'} && $opt{'i'} =~ /^(\d+)$/;
$maxLen     = $1 if $opt{'a'} && $opt{'a'} =~ /^(\d+)$/;
$numLines   = $1 if $opt{'l'} && $opt{'l'} =~ /^(\d+)$/;
$wrdByLines = $1 if $opt{'w'} && $opt{'w'} =~ /^(\d+)$/;
$bitIdx     = $1 if $opt{'e'} && $opt{'e'} =~ /^(\d+)$/;

my $rndBits=int( $numLines * $wrdByLines * $bitIdx / 8 )+
    do{ ( $numLines * $wrdByLines * $bitIdx ) % 8 ? 1 : 0 };

sub syntax {
    printf STDOUT <<eof
Usage: %s [-h] [-d dict file] [-i mIn length] [-a mAx length]
   [-e entropy bits] [-r random file] [-w words] [-l lines] [lines]
Version: %s v%s - (%s).
    -h           This help.
    -l num       number of phrases to generate  (default: %s)
    -w num       number of words by phrase  (default: %s)
    -e bits      Entropy bits for each words (default: %s)
    -d filename  Dictionary file (default: %s)
    -i length    Minimal word length (default: %s)
    -a length    Maximal word length (default: %s)
    -r device    Random file or generator (default: %s)
eof
,$progname,$VERSION{'name'},$VERSION{'number'},$VERSION{'date'},
$numLines,$wrdByLines,$bitIdx,$dict,$minLen,$maxLen,$rndDev;
    exit 0;
};
syntax if $opt{'h'};

die "Min ($minLen) could not be bigger than max ($maxLen)" if $minLen > $maxLen;
die "Number of line to generate could not be 0" unless $numLines;
die "Number of words by phrase to generate could not be 0" unless $wrdByLines;
die "Entropy bits could not be 0" unless $bitIdx;

sub shannonEntropy {
    $_ = $_[0]; my ($H,%ltrs)=(0);
    s/(.)/$ltrs{$1}++;"."/eg;
    foreach ( keys %ltrs ) { my $p = $ltrs{$_} / length( $_[0] );
    		     $H -= $p * log($p); };
    return $H / log(2);
}
sub flatEntropy {
   return length($_[0])*log(26)/log(2);
}

open my $fh, "<".$dict or die "Can't open dictionnary '$dict'";
my %uword;
map { chomp;$uword{$_}++ } grep { /^[a-z]{$minLen,$maxLen}$/ } <$fh>;
close $fh;
my @words=keys %uword;
my $firstBunch=scalar @words;

while (scalar @words > 2**$bitIdx) {
    my $rndIdx=int( rand(1) * scalar @words );
    splice @words, $rndIdx, 1 if $words[$rndIdx]=~/s$/ || int(rand()*3)==2;
}

if (2**$bitIdx > $firstBunch) {
    $bitIdx=int(log($firstBunch)/log(2));
    print "Warning: Bunch of ".$firstBunch." words too small! Entropy bits dropped down to ".$bitIdx." bits index.\n";
};

printf "With %d words over %d ( %6d entropy bits ) = 1/%e -> %d bits.\n",
    $wrdByLines,2**$bitIdx,$bitIdx,2**($wrdByLines*$bitIdx),$wrdByLines*$bitIdx;

printf "With %d words from %d ( %6.3f entropy bits ) = 1/%e -> %.3f bits.\n",
    $wrdByLines,$firstBunch,log($firstBunch)/log(2),
    2**(log($firstBunch)/log(2)*$wrdByLines),
    $wrdByLines*log($firstBunch)/log(2);

open $fh, "<".$rndDev or die;
$_='';
do { sysread $fh, my($buff), $rndBits; $_.=$buff; } while $rndBits > length;
$_ = unpack "B".( $bitIdx * $wrdByLines * $numLines ), $_;

my @out;
my $packBits=$bitIdx;
$packBits=9 if $packBits <9;
s/([01]{$bitIdx})/push @out,$words[unpack("s",pack("b$packBits",$1))];""/eg;

foreach my $i ( 0 .. $numLines-1 ) {
    my @lne=@out[ $wrdByLines * $i .. $wrdByLines * $i + $wrdByLines -1 ];
    printf "%7.3f %7.3f\t".join(" ","%-12s"x$wrdByLines)."\n",
	     shannonEntropy(join "", @lne ) , flatEntropy(join "", @lne ) ,@lne;
};
