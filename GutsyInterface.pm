package GutsyInterface;
use strict;
use warnings;
use GutsyPage;
use GutsyExample;

#print to file, display, and other useful tools for Gutsy

sub print_screen {
	my $comments = shift;
	foreach my $comment (@$comments) {
		print _print_string($comment);
	}
}

sub print_to_text_file {
	my ( $page, $filehandle ) = @_;
	print $filehandle "Gutsy\n" ,  $page->get_title()->format(), "\n";	
	foreach my $comment (@{$page->get_matched()}) {
		print $filehandle _print_string($comment);
	}
}

sub _print_string {
	my $comment = shift;
	return
	"user: "
	. $comment->get_username() . "\n\n"
	. $comment->get_post()->format() . "\n\n";
}

sub print_to_html {
	my ( $page, $filehandle ) = @_;
	print $filehandle
	'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd"><HTML><HEAD>';
	print $filehandle "\n<TITLE>Gutsy ", $page->get_title()->format(), "</TITLE>\n";
	print $filehandle '<link rel="stylesheet" href="sheet.css"></HEAD><BODY>', "\n";
	foreach my $comment (@{$page->get_matched()}) {
		my $username = $comment->get_username();
		print $filehandle "<div class=\"comment\"><a href=https://news.ycombinator.com/user?id=$username>User: $username</a><br>", $comment->get_post()->as_HTML(),
		"\n</div>\n\n";
	}
	print $filehandle "\n\t</BODY>\n</HTML>";
}

sub get_input {
	print join "\n", @_;
	my $input = <STDIN>;
	chomp $input;
	return $input;
}

sub get_url {
	return get_input("input url to download from: ");
}

#sub get_search_term {

#}

sub get_regex {
	return get_input("enter in a valid regex: ");
}

sub pen_write_file {
	my $filename = get_input("enter name of file to write to: ");
	open( my $filehandle, ">", $filename ) or die "$! can't open file";
	return $filehandle;
}

sub option {
	my $coderef = "";
	my @coderefary;
	my ($arrayref) = @_;
	my ( $jobtype, $location, $proglang, $url, $number, $file, $text, $help, $search ) =
	@{$arrayref};
	if ($help) { help(); }
	elsif ( $jobtype ne "" ) {
		$coderef = GutsyExample::get_subroutine( "jobtype", $jobtype );
		if ( $coderef ) {
			push (@coderefary, $coderef)
		}
		else {
			print "Invalid Job Type\n";
		}
	}
	if ( $location ne "" ) {
		$coderef = GutsyExample::get_subroutine( "location", $location );
		if ( $coderef ) { 
			push (@coderefary, $coderef);
		}
		else {
			print "Invalid Location\n";	 
		}
	}
	if  ( $proglang ne "" ) {
		$coderef = GutsyExample::get_subroutine( "proglang", $proglang );
		if ( $coderef ) { 
			push (@coderefary, $coderef);
		}
		else {
			print "Invalid Programming Language\n";	 
		}
	}
	if (!scalar @coderefary) {
		print "default search all entries\n\n";
		$coderef = GutsyExample::default();
		push (@coderefary, $coderef) if $coderef;
	}
	if ( !$url ) {
		$url = "https://news.ycombinator.com/item?id=6995020"; #jan 2014
		print "no url included: using default $url\n";
	}
	if ($search) {push (@coderefary, search($search)); print "searching for $search\n"; } #use search term

	my $page     = GutsyPage->new_complete_url($url);
	my $comment_success = $page->match_comments(\@coderefary);
	my $filename;
	unless ($comment_success) { print "no comments found, aborting printing to file\n"; return;}
	if ($text) {
		$filename = $file || "out.txt";
		open( my $filehandle, ">", $filename ) or die "$! can't open file";
		print_to_text_file( $page, $filehandle );
	}
	else {
		$filename = $file || "out.html";
		open( my $filehandle, ">", $filename ) or die "$! can't open file";
		print_to_html( $page, $filehandle );
	}
		print $page->get_matched_comments_count(), " comments out of ", 
		$page->get_total_comments_count(), " output to $filename\n";
}

sub help {
	die "\thelp for gutsy
	-h|--help this help option 
	-j|--jobtype  [ intern | h1b | remote | entrylevel ]
	-l|--location [ sfbay ]
	-p|--proglang [ perl | ruby | python ]
	-u|url <url to Who's Hiring Thread> default is current month
	-f|--file <filename to save to> default is out.html
	-t|--text print to text instead of html, changes default filename to out.txt
	-s|--search search with a perl regular expression";
}

sub top_menu {
	my $returnval = 0;
	my $toplevel;
	my $exit = 0;
	while ( !$exit ) {
		$toplevel = int get_input(
			"\n1.Job Type \n2.Location \n3.Programming Language \n0. Exit \nEnter number of your choice: "
		);
		if ( $toplevel == 1 ) {
			$returnval = job_menu();
			$exit      = 1;
		}
		elsif ( $toplevel == 2 ) {
			$returnval = location_menu();
			$exit      = 1;
		}
		elsif ( $toplevel == 3 ) {
			$returnval = proglang_menu();
			$exit      = 1;
		}
		elsif ( $toplevel == 0 ) {
			$exit = 1;
		}
		else {
			print "invalid choice\n";
		}
	}
	if ( $returnval == 0 ) { die "$! returnval error"; }

}

sub job_menu {
	my %hash = { 1 => "intern", 2 => "h1b", 3 => "remote" };
	my $value = get_input(
		"Job Menu",
		"\n1. Intern \n2. H1B \n3. Remote \n0. Go Back \nEnter number of your choice: "
	);
	if ( $value && defined $hash{$value} ) {
		return GutsyExample::get_subroutine( 1, $hash{$value} );
	}
	elsif ( $value == 0 ) { return 0; }
	print "invalid option";
	return 0;
}

sub location_menu {
	my %hash = { 1 => "sfbay" };
	my $value = get_input( "Location Menu",
		"\n1. sfbayarea 0. Go Back \nEnter number of your choice: " );
	if ( $value && defined $hash{$value} ) {
		return GutsyExample::get_subroutine( 2, $hash{$value} );
	}
	elsif ( $value == 0 ) { return 0; }
	print "invalid option";
	return 0;
}

sub proglang_menu {
	my %hash = { 1 => "perl" };
	my $value = get_input( "Programming Language Menu",
		"\n1. Perl 0. Go Back \nEnter number of your choice: " );
	if ( $value && defined $hash{$value} ) {
		return GutsyExample::get_subroutine( 3, $hash{$value} );
	}
	elsif ( $value == 0 ) { return 0; }
	print "invalid option";
	return 0;
}

sub search {
	my $pattern = shift;
	my $regex = eval { qr/$pattern/ };
	die "invalid search pattern $@" if $@;
	return sub { 
			my $post = shift;
			return ( $post
				&& $post->get_post()->format() =~
				/$regex/i ) ? 1 : 0;
		}
}

1;
