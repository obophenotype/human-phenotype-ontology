#!/usr/bin/perl -w

use strict;
my %tag_h=();
my $regexp = '';
my $noheader;
my $negate;
my $count;
while ($ARGV[0] =~ /^\-.+/) {
    my $opt = shift @ARGV;
    if ($opt eq '-h' || $opt eq '--help') {
        print usage();
        exit 0;
    }
    if ($opt eq '-r' || $opt eq '--regexp') {
        $regexp = shift @ARGV;
    }
    if ($opt eq '--regexp-file') {
        my $f = shift @ARGV;
        my @or = ();
        open(F,$f);
        while(<F>) {
            chomp;
            push(@or,$_);
        }
        close(F);
        $regexp = sprintf('id: (%s)', join('|',@or));
    }
    if ($opt eq '-c' || $opt eq '--count') {
        $count = 1;
    }
    if ($opt eq '--noheader') {
        $noheader = 1;
    }
    if ($opt eq '-v' || $opt eq '--neg') {
        $negate = 1;
    }
}


$/ = "\n\n";

my $n = 0;
while (@ARGV) {
    my $f = pop @ARGV;
    if ($f eq '-') {
        *F=*STDIN;
    }
    else {
        open(F,$f) || die "cannot open $f";
    }
    my $hdr = 0;
    while(<F>) {
        if (!$hdr && $_ !~ /^\[/) {
            print unless $noheader || $count;
            $hdr = 1;
        }
        else {
            if ($negate) {
                if ($_ !~ /$regexp/) {
                    $n++;
                    print unless $count;
                }
            }
            else {
                if (/$regexp/) {
                    $n++;
                    print unless $count;
                }
            }
        }
    }
}
if ($count) {
    print "$n\n";
}

exit 0;

sub scriptname {
    my @p = split(/\//,$0);
    pop @p;
}


sub usage {
    my $sn = scriptname();

    <<EOM;
$sn [--noheader] [--neg] [--r REGULAR-EXPRESSION] [--regexp-file FILE] OBO-FILE

filters out stanzas from obo files

Example:

$sn -r 'def:.*transcript' go.obo

EOM
}

