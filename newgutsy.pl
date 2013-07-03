#!/usr/bin/perl -w
use strict;
use HTML::TreeBuilder;

my $localfile = "junehiring.html";
open (my $filehandle, "<", $localfile) or die "$!\n";

my $root = HTML::TreeBuilder->new_from_file($filehandle);

#note to self, need to actually start with s.gif width=0
my @users =  $root->look_down("_tag", "a", "href", qr/^user?/);
shift @users; #get rid of who is hiring
foreach my $user (@users) {
$user->attr("href") =~ /^user\?id=(.*)/;
		print $1, "\n", $user->depth(), "\n";
}
