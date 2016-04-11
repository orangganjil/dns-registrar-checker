#!/usr/bin/perl

# dns-check.pl
#
# This script will run a whois check and ensure that reported DNS servers
# match what they should be.
#


use strict;

#### Variables - you will need to edit these for your system. ####
# Path to dig command.
my $dig = "/usr/sbin/dig";

# Path to sendmail binary.
my $sendmail = "/usr/sbin/sendmail -t";

# List of domains to check.
my @domains = ("domain1.com","domain2.com");

# List of allowed DNS server IP addresses. Be sure to escape periods.
my @dnsservers = ("10\.10\.10\.10","10\.10\.10\.11");

# The root name servers to query. I chose to query only four of the 13 roots.
my @rootns = ("a\.gtld-servers\.net\.","b\.gtld-servers\.net\.","c\.gtld-servers\.net\.","d\.gtld-servers\.net\.");

# List of admins to receive email alert.
my @admins = ("youremail@yourdomain.com","anotheremail@yourdomain.com");


my @results = "";
my $dnsresult = "";
my @affecteddomains = "";
# Run dig command.
foreach my $domain (@domains) {
	foreach my $rootns (@rootns) {
		$dnsresult = `$dig \+norec \@$rootns $domain ns` or die "Cannot run dig: $!";
		foreach my $dnsserver (@dnsservers) {
			if (grep /$dnsserver/, $dnsresult) {
				push @results, "0";
			} else {
				push @results, "1";
				if (grep /$domain/, @affecteddomains) {
				} else {
					push @affecteddomains, "$domain";
				}
			}
		}
	}
}

# Check for modified DNS.
if (grep /1/, @results) {
	open(SENDMAIL, "|$sendmail") or die "Cannot open $sendmail: $!";
	# Update your from email address.
	print SENDMAIL "From: noreply\@yourdomain.com\n";
	foreach my $admin (@admins) {
		print SENDMAIL "To: <$admin>\n";
	}
	print SENDMAIL "Subject: Potential Registrar Hijack\n\n";
	print SENDMAIL "The following domains may have been hijacked:\n";
	foreach my $affecteddomain (@affecteddomains) {
		print SENDMAIL "$affecteddomain\n";
	}
	close (SENDMAIL);
}
