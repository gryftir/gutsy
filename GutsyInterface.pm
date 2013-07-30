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

#sub print_to_html {

#}

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
