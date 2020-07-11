#!/usr/bin/env perl
# grep.pl - faster grep. See https://github.com/fordsfords/grep.pl
#
# Licensed under CC0. See https://github.com/fordsfords/pgrep/LICENSE

use strict;
use warnings;
use Getopt::Std;
use File::Basename;

# globals
my $tool = basename($0);
my $usage_str = "$tool [-h] [-i] [-n] [-o re_opts] pattern [file ...]";

# Process options.
my $re_opts = "";
use vars qw($opt_h $opt_i $opt_n $opt_o);
getopts('hino:') || usage();

if (defined($opt_h)) {
  help();
}
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
while (<>) {
  if (/$re_opts$pat/) {
    my $prefix = "";
    if ($num_files > 1) { $prefix .= "$ARGV:"; }
    if ($opt_n) { $prefix .= "$.:"; }
    print "$prefix$_";

    $exit = 0;  # return success.
  }
} continue {  # This continue clause makes "$." give line number within file.
  close ARGV if eof;
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

  exit(1);
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
    -n - include line numbers.
    -o re_opts - Perl regular expression options.
    pattern - Perl regular expression.
    file ... - zero or more input files.  If omitted, inputs from stdin.

__EOF__

  exit(0);
}  # help
