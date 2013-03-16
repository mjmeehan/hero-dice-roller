#!/usr/bin/perl
use Games::Dice qw(roll_array roll);
use List::Util qw(reduce sum);
use POSIX qw(floor);
use Term::ANSIColor;
use Getopt::Std;
use Switch;
#use warnings;
use strict;

sub colorize;

our $opt_k;
my $dice = $ARGV[0];
my ($stun, $body);
getopt('k:');
my @roll;

my $mode;
if($opt_k) {
	$mode = "Killing attack";
} elsif (scalar(@ARGV) == 1) {
	$mode = "Normal attack";
} else {
	$mode = "Skill Test";
}

print "$mode\n";
my (@roll, $stun, $body);
switch ($mode) {
case "Killing attack" {
	@roll = roll_array($opt_k . "d6");
	colorize(@roll);
	$body = sum @roll;
	my $kill = roll('1d6') - 1;
	$kill = $kill == 0 ? 1 : $kill;
	$stun = $body * $kill;
	print "$body * $kill = $stun\n";
} case "Normal attack" {
	@roll = roll_array($dice . "d6");
	colorize(@roll);
	$stun =  sum @roll;
	$body = reduce { $a + floor($b/2) } 0, @roll;
} else {
	@roll = roll_array("3d6");
	print join(" ", @roll) . "\n";
	print sum(@roll) . "\n";
	exit(1);
}
}

print "Stun: $stun\n";
print "Body: $body\n";

########

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
