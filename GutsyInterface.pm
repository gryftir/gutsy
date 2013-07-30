package GutsyInterface;
use strict;
use warnings;
#print to file, display, and other useful tools for Gutsy

sub print_screen {
 my $comments = shift;
 foreach my $comment (@$comments) {
	 print _print_string($comment);
 }
}

sub print_to_text_file {
 my ($comments, $filehandle) = shift;
 foreach my $comment (@$comments) {
	 print $filehandle _print_string($comment);
	 }
}

sub _print_string {
	my $comment = shift;
	return "user: " .  $comment->get_username() . "\n\n" . $comment->get_post()->format() . "\n\n";
}

sub print_to_html {
	my ($comments, $filehandle) = @_;
	print $filehandle '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd"><HTML><HEAD><TITLE>Gutsy</TITLE><link rel="stylesheet" href="sheet.css"></HEAD><BODY>';
	foreach my $comment (@$comments) {
		print $filehandle  "\n<div>", $comment->get_post()->as_HTML(),"\n</div>";
	}
		print $filehandle "\n\t</BODY>\n</HTML>";
}

sub get_input {
  print join "\n", @_; 
	my $input = <STDIN>;
	return $input;
}

sub get_url {
return get_input("input url to download from: ");
}

#sub get_search_term {

#}

sub search_comments {
	my $comments = shift;
 my	@searchterms = @_;

}
1;
