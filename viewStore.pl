#!/usr/bin/perl

print "Content-type:text/html\n\n";
use strict;
use warnings;
use CGI qw/:standard/;
use DBI;

my $store_number = param("store_number")||"";

print qq(<!DOCTYPE html>);

open(DB_INFO, "/home/da21066/public_html/SE/db_info");
my $count = 0;
my $username = "";
my $password = "";
while(<DB_INFO>){
    if ($count == 0) {
	$username = "$_";
    }    if ($count == 1) {
	$password = "$_";
    }
    $count = $count + 1;
}

if ($store_number) {
    print qq(<br />Getting information for Store #$store_number....<br />);
    viewStore($store_number);
}

print qq(</body></html>);

sub viewStore {

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
my $dbh=DBI->connect($dsn, $username, $password) or die "Error opening database: $DBI::errstr\n";

my $stmt = "INSERT into stores (Number, Address, Manager) values ($store_number, '$address', '$manager')";

my $sth=$dbh->prepare($stmt);

if($sth->execute()) {
    print qq(<br />Success!<br />);

} else {
    print qq(<br />Something terrible has happened, try again<br />);
}

}
