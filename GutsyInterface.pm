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
	my ( $comments, $filehandle ) = shift;
	foreach my $comment (@$comments) {
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
	my ( $comments, $filehandle ) = @_;
	print $filehandle
	'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd"><HTML><HEAD><TITLE>Gutsy</TITLE><link rel="stylesheet" href="sheet.css"></HEAD><BODY>';
	foreach my $comment (@$comments) {
		my $username = $comment->get_username();
		print $filehandle "<div><a href=https://news.ycombinator.com/user?id=$username>User: $username</a><br>", $comment->get_post()->as_HTML(),
		"\n</div>";
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
		print "default internship search\n\n";
		$coderef = GutsyExample::get_subroutine("jobtype" , "intern" );
		push (@coderefary, $coderef) if $coderef;
	}
	if ( !$url ) {
		$url = "https://news.ycombinator.com/item?id=6310234";
		print "no url included: using default $url\n";
	}
	if ($search) {push (@coderefary, search($search))  }; #use search term

	my $page     = GutsyPage->new_complete_url($url);
	my $comments = $page->match_comments(\@coderefary);
	my $filename;
	if ($text) {
		$filename = $file || "out.txt";
		open( my $filehandle, ">", $filename ) or die "$! can't open file";
		print_to_text_file( $comments, $filehandle );
	}
	else {
		$filename = $file || "out.html";
		open( my $filehandle, ">", $filename ) or die "$! can't open file";
		print_to_html( $comments, $filehandle );
	}
		print scalar @$comments, " comments output to $filename\n";
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
