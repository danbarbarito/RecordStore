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
    print qq(<br />Getting orders for Store #$store_number....<br />);
    viewOrders($store_number);
}

print qq(</body></html>);

sub viewOrders {

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

my $stmt = "SELECT * from orders WHERE Store = '$store_number'";
my $sth=$dbh->prepare($stmt);

my @store_info;

$sth->execute();
print qq(<h2>);
while(@store_info = $sth->fetchrow_array()) {
    my $order_number = $store_info[0];
    my $date = $store_info[1];
    my $store = $store_info[2];
    my $price = $store_info[3];
    print qq(Order #$order_number: $date, $price <br />);
}
print qq(</h2>);

if($sth->rows == 0) {
    print qq(<b> No orders found <b/>);

}

}
