#!/usr/bin/perl -w

use strict;
my %tag_h=();
my $negate = 0;
my $typedef = 1;
my $show_header = 1;
while ($ARGV[0] =~ /^\-/) {
    my $opt = shift @ARGV;
    if ($opt eq '-h' || $opt eq '--help') {
        print usage();
        exit 0;
    }
    elsif ($opt eq '--typedef') {
        $typedef = 1; # now the default
    }
    elsif ($opt eq '--no-typedef') {
        $typedef = 0;
    }
    elsif ($opt eq '--no-header') {
        $show_header = 0;
    }
    elsif ($opt eq '-n' || $opt eq '--negate') {
        $negate = 1;
    }
    elsif ($opt eq '-t' || $opt eq '--tag') {
        $tag_h{shift @ARGV} = 1;
    }
    elsif ($opt eq '-') {
    }
    else {
        die "$opt";
    }
}
#if (!@ARGV) {
#    print usage();
#    exit 1;
#}
print STDERR "Tags: ", join(', ',keys %tag_h),"\n";

my $on = 1;
my $in_header = 1;
my @lines = ();
while (<>) {
    push(@lines,$_);
}
while($_ = shift @lines) {
    if (/^\[(\S+)\]/) {
        $in_header=0;
	if ($1 eq 'Typedef' && !$typedef) {
	    $on = 0;
	}
	else {
	    $on = 1;
	}
    }

    if (!$on) {
	next;
    }

    if ($in_header) {
        if ($show_header) {
            print;
        }
    } 
    else {
        if (/^(\w+):\s*(.*)/) {
	    my $tag = $1;
	    my $val = $2;
            if ($tag_h{$tag}) {
		if ($tag eq 'id' && $lines[0] =~ /name: (.*)/) {
		    print "id: $val ! $1\n";
		}
		else {
                    if (!$negate) {
                        print;
                    }
		}
            } else {
                if ($negate) {
                    print;
                }
                # FILTER
            }
        } 
	else {
            print;
        }
    }
}


exit 0;

sub scriptname {
    my @p = split(/\//,$0);
    pop @p;
}


sub usage {
    my $sn = scriptname();

    <<EOM;
$sn [-t tag]* [--no-header] FILE [FILE...]

strips all tags except selected

Example:

$sn  -t id -t xref gene_ontology.obo

EOM
}

