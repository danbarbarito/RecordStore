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
    print qq(<br />Deleting Store #$store_number....<br />);
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

my $stmt = "DELETE FROM stores WHERE Store='$store_number'";
my $sth=$dbh->prepare($stmt);

my @store_info;

$sth->execute();

while(@store_info = $sth->fetchrow_array()) {
    my $sn = $store_info[0];
    my $address = $store_info[1];
    my $manager = $store_info[2];
    print qq(<h2>Store #$sn is located at $address and is managed by $manager);
}

if($sth->rows == 0) {
    print qq(<b> No store found <b/>);

}

}
