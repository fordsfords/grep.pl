# grep.pl
Perl-based grep replacement.

This Perl program replaces Unix grep for most straight-forward
uses.
It is MUCH faster than grep and egrep and even fgrep for large files.
However, it does not have the same richness of command-line
options.

Someday I'll add the "-r" option.


## Quickstart

This assumes your PATH includes ~/bin and also assumes your system has "wget".
(For Mac users, use "brew install wget".)

````
$ wget -O ~/bin/grep.pl https://github.com/fordsfords/grep.pl/raw/master/grep.pl
$ chmod ~/bin/grep.pl
$ grep.pl ford ~/bin/grep.pl
# grep.pl - faster grep. See https://github.com/fordsfords/grep.pl
# Licensed under CC0. See https://github.com/fordsfords/pgrep/LICENSE
````

## Usage

````
Usage: grep.pl [-h] [-i] [-n] [-o re_opts] [file ...]
Where:
    -h - help.
    -i - case insensitive search.
    -n - include line numbers.
    -o re_opts - Perl regular expression options.
    file ... - zero or more input files.  If omitted, inputs from stdin.
````

## Performance data

These timings taken on a Macbook Pro using a text file containing
over 195 million lines.
(I omitted sys and user times.)

````
$ time cat dbglog.txt >/dev/null
real 0m35.423s
 
$ time wc dbglog.txt
195177935 1177117603 28533284864 dbglog.txt
real 1m44.560s

$ time egrep '999999' dbglog.txt
real 7m39.737s

$ time fgrep '999999' dbglog.txt
real 7m11.365s

$ time grep.pl '999999' dbglog.txt
real  2m8.341s
````

## License

Copyright 2020 Steven Ford http://geeky-boy.com and licensed
"public domain" style under
[CC0](http://creativecommons.org/publicdomain/zero/1.0/):
![CC0](https://licensebuttons.net/p/zero/1.0/88x31.png "CC0")

To the extent possible under law, the contributors to this project have
waived all copyright and related or neighboring rights to this work.
In other words, you can use this code for any purpose without any
restrictions.  This work is published from: United States.  The project home
is https://github.com/fordsfords/rstone

To contact me, Steve Ford, project owner, you can find my email address
at http://geeky-boy.com.  Can't see it?  Keep looking.
