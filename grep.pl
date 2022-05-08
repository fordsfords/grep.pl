#!/usr/bin/env perl
# grep.pl - faster grep. See https://github.com/fordsfords/grep.pl
#
# This code and its documentation is Copyright 2021 Steven Ford
# and licensed "public domain" style under Creative Commons "CC0":
#   http://creativecommons.org/publicdomain/zero/1.0/
# To the extent possible under law, the contributors to this project have
# waived all copyright and related or neighboring rights to this work.
# In other words, you can use this code for any purpose without any
# restrictions.  This work is published from: United States.  The project home
# is https://github.com/fordsfords/grep.pl

use strict;
use warnings;
use Getopt::Std;
use File::Basename;

# globals
my $tool = basename($0);
my $usage_str = "$tool [-h] [-i] [-l] [-n] [-o re_opts] [-v] [-V] pattern [file ...]";

# Process options.
use vars qw($opt_h $opt_i $opt_l $opt_n $opt_o $opt_v $opt_V);
getopts('hilno:vV') || usage();

if (defined($opt_h)) {
  help();
}

my $re_opts = "";  # Accumulate regular expression options.
if (defined($opt_o)) {
  $re_opts .= $opt_o;
}
if (defined($opt_i)) {
  $re_opts .= 'i';
}

if (length($re_opts)) {
  # Add RE options to pattern instead of after trailing slash.
  # See https://perldoc.perl.org/perlreref.html#EXTENDED-CONSTRUCTS
  $re_opts = "(?$re_opts)";
}

if (scalar(@ARGV) == 0) {
  usage();
}

# Get pattern out of @ARGV so diamond operator (<>) won't try to open it.
my $pat = shift;

my $num_files = scalar(@ARGV);

# Main loop; read each line in each file.
my $exit = 1;

$pat = "$re_opts$pat";

if ($opt_v) {  # -v
  # WARNING, the main loop is replicated below (else of -v).
  while (<>) {
    if (! /$pat/) {
      my $prefix = "";
      if ($num_files > 1) { $prefix .= "$ARGV:"; }
      if ($opt_n) { $prefix .= "$.:"; }

      if ($opt_l) {
        if ($opt_V) {
          print "$prefix$_";
        } else {
          print "$ARGV\n";
        }
        close ARGV;  # First match, skip to next file.
      }
      else {
        print "$prefix$_";
      }

      $exit = 0;  # return success.
    }
  } continue {  # This continue clause makes "$." give line number within file.
    close ARGV if eof;
  }
}
else {  # not -v
  # WARNING, the main loop is replicated above (if of -v).
  while (<>) {
    if (/$pat/) {
      my $prefix = "";
      if ($num_files > 1) { $prefix .= "$ARGV:"; }
      if ($opt_n) { $prefix .= "$.:"; }

      if ($opt_l) {
        if ($opt_V) {
          print "$prefix$_";
        } else {
          print "$ARGV\n";
        }
        close ARGV;  # First match, skip to next file.
      }
      else {
        print "$prefix$_";
      }

      $exit = 0;  # return success.
    }
  } continue {  # This continue clause makes "$." give line number within file.
    close ARGV if eof;
  }
}

# All done.
exit($exit);


# End of main program, start subroutines.


sub usage {
  my($err_str) = @_;

  if (defined $err_str) {
    print STDERR "$tool: $err_str\n\n";
  }
  print STDERR "Usage: $usage_str\n\n";

  exit(2);  # Match what grep does.
}  # usage


sub help {
  my($err_str) = @_;

  if (defined $err_str) {
    print "$tool: $err_str\n\n";
  }
  print <<__EOF__;
Usage: $usage_str
Where:
    -h - help.
    -i - case insensitive search.
    -l - list files.
    -n - include line numbers.
    -o re_opts - Perl regular expression options.
    -v - invert match (select lines *not* matching pattern).
    -V - verbose (i.e. print matched line with -l).
    pattern - Perl regular expression.
    file ... - zero or more input files.  If omitted, inputs from stdin.

__EOF__

  exit(0);
}  # help
