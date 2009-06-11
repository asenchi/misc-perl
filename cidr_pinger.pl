#!/usr/bin/perl -w
use strict;
use warnings;
use Net::Netmask;
use Net::Ping;

my $ip_range = shift || die "cidr_striped.pl: <CIDR IP Range> [timeout]\n";
my $timeout = shift || 2;

my $p = Net::Ping->new( 'tcp', $timeout );
$p->hires();

my $block = new Net::Netmask($ip_range);

for my $ip_addy ($block->enumerate) {
  next if ($ip_addy eq $block->base() || $ip_addy eq $block->broadcast());

  my ($ret, $duration, $ip) = $p->ping($ip_addy);

  if ($ret) {
    printf("$ip is alive (time=%.2f ms)\n", 1000 * $duration) if $ret;
  } else {
    print "$ip is down!\n";
  }
}
