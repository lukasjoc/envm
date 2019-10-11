#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Time::Piece;
use Time::Seconds;
use Getopt::Long;
use Data::Munge qw(elem);
use IO::CaptureOutput qw(capture_exec);
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
my ($stdout, $stderr);

use constant  {
    SNAPSHOT_DAYS          => ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
    SNAPSHOT_MAX_DELETIONS => 2,
    SNAPSHOT_LIVESPAN      => ONE_WEEK,
    VBoxManage             => 'VBoxManage',
    VBoxHeadless           => 'VBoxHeadless',
};

GetOptions(
    "verbose!"  => \my $verbose,
    "start!"    => \my $start,
    "stop!"     => \my $stop,
    "create!"   => \my $snapshot,
    "delete!"   => \my $delete,
    "vm=s"      => \my $VM_NAME,
) or die("Error in command line arguments\n");

print "\N{U+1F60A} managing $VM_NAME...\n" if ($verbose);

# take snapshots
if ($snapshot) {
    my $now = localtime;
    my $snapshot_name = $now->strftime('%d.%m.%Y - %H:%M');
    if (elem($now->fullday, SNAPSHOT_DAYS)) {
        print "\N{U+1F4F7} creating snapshot $snapshot_name of $VM_NAME...\n" if ($verbose);
        my ($stdout, $stderr) = capture_exec(VBoxManage, 'snapshot', $VM_NAME, 'take', $snapshot_name);
        print $stdout, $stderr if ($verbose);
    }
    else {
        print "\N{U+1F6D1} no snapshot needed...\n"  if ($verbose);
    }
};

# delete older snapshots
if ($delete) {
    print "\N{U+2705} check snapshots of $VM_NAME...\n"  if ($verbose);
    my $stdout = capture_exec(VBoxManage, 'snapshot', $VM_NAME, 'list');
    my @vms = split('\n', $stdout);
    for my $vms (@vms) {
        $vms =~ s/^\s*Name:\s+(.*)\s+\(UUID.*$/$1/xms;
    }
    @vms = sort { join('', (split '.', $a)[2,1,0]) cmp join('', (split '.', $b)[2,1,0]) } @vms;

    # get time
    my $limit = localtime;
    $limit -= SNAPSHOT_LIVESPAN;

    my $delete = SNAPSHOT_MAX_DELETIONS;
    for my $date (@vms) {
        next if $date !~ m{^\d+\.\d+\.\d+ - \d+:\d+$};
        my $time = Time::Piece->strptime($date, "%d.%m.%Y - %H:%M");
        if ($time < $limit && $delete) {
            print "\N{U+274C} delete snapshot $date of $VM_NAME...\n"  if ($verbose);
            my ($stdout, $stderr) = capture_exec(VBoxManage, 'snapshot', $VM_NAME, 'delete', $date);
            print $stdout, $stderr if ($verbose);
            $delete--;
        }
    }
}

# start vm
if ($start) {
    print "\N{U+1F680} starting vm $VM_NAME...\n" if ($verbose);
    exec(VBoxHeadless, '-s', $VM_NAME);
} elsif ($stop) {
    print "\N{U+2764} stopping vm $VM_NAME...\n" if ($verbose);
    exec(VBoxManage, 'controlvm', $VM_NAME, 'acpipowerbutton');
}
