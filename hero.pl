#!/usr/bin/perl
#
use Games::Dice qw(roll_array roll);
use List::Util qw(reduce sum);
use POSIX qw(floor);
use Term::ANSIColor;
use Getopt::Std;

#use warnings;
use strict;
our $opt_k;
my $dice = $ARGV[0];
my ($stun, $body);
getopt('k:');
my @roll;

sub colorize {
	(@roll) = @_;
	my $color;
	foreach my $roll (@roll) {
		if($roll == 1) {
			$color = "cyan";
		} elsif($roll == 6) {
			$color = "bright_red";
		} else {
			$color = "white";
		}
		print colored [$color], $roll . " ";

	}
	print "\n";
}

if($opt_k) {
	print "Killing attack\n";
	@roll = roll_array($opt_k . "d6");
	colorize(@roll);
	$body = sum @roll;
	my $kill = roll('1d6') - 1;
	$kill = $kill == 0 ? 1 : $kill;
	$stun = $body * $kill;
	print "$body * $kill = $stun\n";
} elsif (scalar(@ARGV) == 1) {
	print "Normal attack\n";
	@roll = roll_array($dice . "d6");
	colorize(@roll);
	$stun =  sum @roll;
	$body = reduce { $a + floor($b/2) } 0, @roll;
} else {
	print "Skill test\n";
	@roll = roll_array("3d6");
	print join(" ", @roll) . "\n";
	print sum(@roll) . "\n";
	exit(1);
}

print "Stun: $stun\n";
print "Body: $body\n";
