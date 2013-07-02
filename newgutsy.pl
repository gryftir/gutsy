#!/usr/bin/perl -w
use strict;
use HTML::TreeBuilder;

my $localfile = "junehiring.html";

open (my $filehandle, "<", $localfile) or die "$!\n";

my $root = HTML::TreeBuilder->new_from_file($filehandle);

my @tableelements = $root->look_down("_tag", "tr");
foreach  my $table (@tableelements) {
	if ($table->look_down("_tag", "img", "width", 0) ){
		print $table->as_text(), "\n";
		}
	}
