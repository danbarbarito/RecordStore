#!/usr/bin/perl

print "Content-type:text/html\n\n";
use strict;
use warnings;
use CGI qw/:standard/;
use DBI;
use Cwd;

my $store_number = param("store_number")||"";
my $address = param("address")||"";
my $manager = param("manager")||"";
print qq(<!DOCTYPE html>);

if ($store_number && $address && $manager) {
    print qq(<br />Creating store $store_number located at $address with manager $manager....<br />);
    createStore($store_number, $address, $manager);
}

print qq(</body></html>);

sub createStore {

my $dsn =  "dbi:mysql:andrewolsen:panther.adelphi.edu";
my $username = "";
my $password = "";
my $count = 0;
my $filename = "/home/da21066/public_html/SE/db_info";
open(my $fh, "<:encoding(UTF-8)", $filename) or print "Cant open db_info";
while(my $row = <$fh>) {
    chomp($row);
    if ($count == 0) {
	$username = "$row";
    }
    if ($count == 1) {
	$password = "$row";
    }
    $count = $count + 1;
}

my $dbh=DBI->connect($dsn, $username, $password) or print "Error opening database: $DBI::errstr\n";

my $stmt = "INSERT into stores (Number, Address, Manager) values ($store_number, '$address', '$manager')";

my $sth=$dbh->prepare($stmt);

if($sth->execute()) {
    print qq(<br />Success!<br />);

} else {
    print qq(<br />Something terrible has happened, try again<br />);
}

}
