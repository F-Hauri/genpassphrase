genpassphrase
=============

Take clean word from dictionary to build random pass phrase with fixed entropy

In the following of the idea found at: http://xkcd.com/936/

There is a perl script that take a `dictionary` file,
create a uniq clean (with only lower letters from `a` to `z`) words list
and take randoms words to build a pass phrase.

Syntaxe:
--------
<pre>
Usage: passphrase.pl [-h] [-d dict file] [-i mIn length] [-a mAx length]
   [-e entropy bits] [-r random file] [-w words] [-l lines] [lines]
   
    -h           This help.
    -l num       number of phrases to generate  (default: 1)
    -w num       number of words by phrase  (default: 5)
    -e bits      Entropy bits for each words (default: 15)
    -d filename  Dictionary file (defaul /usr/share/dict/american-english)
    -i length    Minimal word length (default: 4)
    -a length    Maximal word length (default: 11)
    -r device    Random file or generator (default: /dev/urandom)
</pre>

Output sample:
--------------
<pre>
$ ./passphrase.pl -l 4
With 5 words over 32768 (     15 entropy bits ) = 1/3.777893e+22 -> 75 bits.
With 5 words from 56947 ( 15.797 entropy bits ) = 1/5.988999e+23 -> 78.987 bits.
  3.698 cardiology  naysayer    unsure      leggier     stencilled  
  3.634 meteoroids  sisterhood  tithes      scansion    blacksmiths 
  3.926 nuzzled     uninvited   rumbaed     shebang     expurgate   
  3.830 mishapping  foreseeable hilarious   forded      infinite    
</pre>

Explanation: There are 56947 word (15.79bits) containing 4 to 11 letters in /usr/share/dict/american-english,
after randomly dropped this down to 32768 (round to 15 bits entropy), building lines of 5 random words,
compute shannon's entropy for each lines and printout.