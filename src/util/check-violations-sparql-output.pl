#!/usr/bin/perl
use strict;
my $n=0;
my %n_by_f = ();
foreach my $f (@ARGV) {
    my @fails = ();
    open(F,$f) || die $f;
    my $hdr = <F>;
    foreach (<F>) {
        chomp;
        print STDERR " * violation:\n    OUT: $_\n    FILE: $f\n\n";
        $n++;
        $n_by_f{$f}++;
    }
    close(F);
}
print "\n---\n";
print "Total Fails: $n\n";
foreach my $k (keys %n_by_f) {
    print " * $k: $n_by_f{$k}\n";
}
exit($n);
