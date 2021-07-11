# grep.pl
Perl-based grep replacement.

This Perl program replaces Unix grep for most straight-forward
uses.
It is MUCH faster than grep and egrep and even fgrep for large files.
However, it does not have the same richness of command-line
options.

Someday I'll add the "-r" option.

**ATTENTION** See [Security Warning](#security-warning) below.


## Quickstart

This assumes your PATH includes ~/bin and also assumes your system has "wget".
(For Mac users, use "brew install wget".)

````
$ wget -O ~/bin/grep.pl https://github.com/fordsfords/grep.pl/raw/master/grep.pl
$ chmod +x ~/bin/grep.pl
$ grep.pl ford ~/bin/grep.pl
# grep.pl - faster grep. See https://github.com/fordsfords/grep.pl
# Licensed under CC0. See https://github.com/fordsfords/pgrep/LICENSE
````


## Usage

````
$ grep.pl -h
Usage: grep.pl [-h] [-i] [-l] [-n] [-o re_opts] [-v] [-V] pattern [file ...]
Where:
    -h - help.
    -i - case insensitive search.
    -l - list files.
    -n - include line numbers.
    -o re_opts - Perl regular expression options.
    -v - invert match (select lines *not* matching pattern).
    -V - verbose (e.g. print matched line with -l).
    pattern - Perl regular expression.
    file ... - zero or more input files.  If omitted, inputs from stdin.
````

## Performance data

These timings taken on a Macbook Pro using a text file containing
over 195 million lines.
(I omitted sys and user times.)

````
$ time grep.pl '9999999' dbglog.txt
real  2m8.341s
````

Let's compare that to some other commands:

````
$ time cat dbglog.txt >/dev/null
real 0m35.423s
 
$ time wc dbglog.txt
195177935 1177117603 28533284864 dbglog.txt
real 1m44.560s

$ time egrep '9999999' dbglog.txt
real 7m39.737s

$ time fgrep '9999999' dbglog.txt
real 7m11.365s

$ time sed -n '/9999999/p' dbglog.txt 
real	9m56.572s
````

## Security Warning

This tool uses the Perl null angle operator "<>" (a.k.a. "diamond operator"),
which uses the Perl 2-argument "open" API, which treats certain
specially-named files differently than normal files. For example, it treats
a file named "-" as reading standard input. And treats a file name that ends
with the pipe character "|" as reading the output from a command.
This can be a powerful tool, which is why I used it, but it can also be
a security risk if a bad actor creates a file with a carefully-crafted name.

See
https://blog.geeky-boy.com/2020/07/perl-diamond-operator.html#Security_Warning
for more information.


## License

I want there to be NO barriers to using this code, so I am releasing it to the public domain.  But "public domain" does not have an internationally agreed upon definition, so I use CC0:

Copyright 2020 Steven Ford http://geeky-boy.com and licensed
"public domain" style under
[CC0](http://creativecommons.org/publicdomain/zero/1.0/):
![CC0](https://licensebuttons.net/p/zero/1.0/88x31.png "CC0")

To the extent possible under law, the contributors to this project have
waived all copyright and related or neighboring rights to this work.
In other words, you can use this code for any purpose without any
restrictions.  This work is published from: United States.  The project home
is https://github.com/fordsfords/grep.pl

To contact me, Steve Ford, project owner, you can find my email address
at http://geeky-boy.com.  Can't see it?  Keep looking.
