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
		$user->attr("href") =~ /^user\?id=(.*)/;
		print"\nuser ", $1, "\n\n";
		my $font = $user->look_up("_tag", "td")->look_down("_tag", "font");
		print $font->as_text(), "\n";	
#		foreach my $tagname ($user->lineage()) {
#			print $tagname->tag(), " ";
#			my $text = $tagname->look_down("_tag", "font");
#			if ($text) {
#				print $text->as_text(), "\n";
#				last;
#			}
#		}
	}
}
#my @users =  $root->look_down("_tag", "a", "href", qr/^user?/);
#shift @users; #get rid of who is hiring
#foreach my $user (@users) {
#$user->attr("href") =~ /^user\?id=(.*)/;
#		print $1, "\n", $user->depth(), "\n";
#}
