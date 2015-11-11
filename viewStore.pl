#!/usr/bin/perl

print "Content-type:text/html\n\n";
use strict;
use warnings;
use CGI qw/:standard/;
use DBI;

my $store_number = param("store_number")||"";

print qq(<!DOCTYPE html>);


if ($store_number) {
    print qq(<br />Getting information for Store #$store_number....<br />);
    viewStore($store_number);
}

print qq(</body></html>);

sub viewStore {

my $dsn =  "dbi:mysql:andrewolsen:panther.adelphi.edu";
my $dbh=DBI->connect($dsn, "andrewolsen", "g6ajW8r2") or die "Error opening database: $DBI::errstr\n";

my $stmt = "INSERT into stores (Number, Address, Manager) values ($store_number, '$address', '$manager')";

my $sth=$dbh->prepare($stmt);

if($sth->execute()) {
    print qq(<br />Success!<br />);

} else {
    print qq(<br />Something terrible has happened, try again<br />);
}

}
