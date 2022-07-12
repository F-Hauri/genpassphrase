genpassphrase
=============

== We're Using GitHub Under Protest ==

This project is currently hosted on GitHub.  This is not ideal; GitHub is a
proprietary, trade-secret system that is not Free and Open Souce Software
(FOSS).  We are deeply concerned about using a proprietary system like GitHub
to develop our FOSS project.  For further version of this projects, have a look
[My web bazzar ](https://f-hauri.ch/vrac/?C=M;O=D) where most of my ideas are
still published until I made a choice for further shares...

We urge you to read about the [Give up GitHub](https://GiveUpGitHub.org)
campaign from [the Software Freedom Conservancy](https://sfconservancy.org) to
understand some of the reasons why GitHub is not a good place to host FOSS
projects.

If you are a contributor who personally has already quit using GitHub, please
[send mail to gitproj@f-hauri.ch](mailto:gitproj@f-hauri.ch) for any comment
or contributions without using GitHub directly.

Any use of this project's code by GitHub Copilot, past or present, is done
without our permission.  We do not consent to GitHub's use of this project's
code in Copilot.

![Logo of the GiveUpGitHub campaign](https://sfconservancy.org/img/GiveUpGitHub.png)

Copying:
--------

This stuff is distrubuted under GNU GPL v3.0 or later license.

Introduction:
-------------

This pass phrase generator take clean words from dictionary to build random phrases and compute entropy.

Follow the idea found at: http://xkcd.com/936/

It is a perl script that take a `dictionary` file,
create a uniq cleaned words list (with only flat lower letters from `a` to `z`)
take randoms words and compute entropy.

Syntaxe:
--------
<pre>
Usage: passphrase.pl [-h] [-q] [-d dict file] [-s outputfile]
   [-i mIn length] [-a mAx length] [-e entropy bits] [-r random file]
   [-w words] [-l lines] [lines]
Version: passphrase.pl v1.5.1.2 - (2013-07-05 08:51:52).
    -h           This help.
    -l num       number of phrases to generate  (default: 1)
    -w num       number of words by phrase  (default: 5)
    -e bits      Entropy bits for each words (default: 15)
    -d filename  Dictionary file (default: /usr/share/dict/american-english)
    -s filename  Dict file to save after initial drop (default: none)
    -i length    Minimal word length (default: 4)
    -a length    Maximal word length (default: 11)
    -r device    Random file or generator (default: /dev/urandom)
    -q           Quietly generate lines without computations.
</pre>

Output sample:
--------------
<pre>
$ ./passphrase.pl -l 4
With 5 words over 32768 (     15 entropy bits ) = 1/3.777893e+22 -> 75 bits.
With 5 words from 56947 ( 15.797 entropy bits ) = 1/5.988999e+23 -> 78.987 bits.
  3.634 192.718 airfoils    desolated   babysitting hits        digresses   
  3.391 173.916 acidic      parents     scary       trespassed  fascinate   
  3.704 164.515 occluded    rarely      sweatier    metallic    squat       
  3.907 192.718 available   stockpiling blazoning   jaywalk     chino       
</pre>

Explanation: There are 56947 word (15.79bits) containing 4 to 11 letters in /usr/share/dict/american-english,
after randomly dropped this down to 32768 (round to 15 bits entropy), building lines of 5 random words,
compute shannon's entropy and flat entropy, for each lines and printout.

Or simply:
<pre>
$ ./genpassphrase.pl -q
firmly predeceased titanium slobbered betrayers
</pre>
