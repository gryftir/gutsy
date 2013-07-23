#!/usr/bin/perl -w
use strict;
use HTML::TreeBuilder;

my $localfile = "junehiring.html";
open (my $filehandle, "<", $localfile) or die "$!\n";
my @pages; #for the More Pages.  Note class="title" 2 on first page q, 1 on intermediate page, none on last page.
my $root = HTML::TreeBuilder->new_from_file($filehandle);


my @posts = $root->look_down("_tag", "img", 
	"width", "0",
	"src", "s.gif");
foreach my $post (@posts) {
	my @line = $post->lineage();
	my $user = $line[0]->right();
	if ($user) {
		$user = $user->right()->look_down("_tag", "a", "href", qr/^user?/);
		my $font = $user->look_up("_tag", "td")->look_down("_tag", "font");
		if ($font->as_text()	=~ /[[:^alpha:]](intern|internship)[sS]?[[:^alpha:]]/i) {
			$user->attr("href") =~ /^user\?id=(.*)/;
			print"\nuser ", $1, "\n\n";
			print $font->as_text(), "\n";
		}
	}
}
