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
    return 0;
}

sub print_to_text_file {
    my ( $page, $filehandle ) = @_;
    print $filehandle "Gutsy\n", $page->get_title()->format(), "\n";
    foreach my $comment ( @{ $page->get_matched() } ) {
        print $filehandle _print_string($comment);
    }
    return scalar @{ $page->get_matched() };
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
'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN http://www.w3.org/TR/html4/loose.dtd"><HTML><HEAD>';
    print $filehandle "\n<TITLE>Gutsy ", $page->get_title()->format(),
      "</TITLE>\n";
    print $filehandle '<link rel="stylesheet" href="sheet.css"></HEAD><BODY>',
      "\n";
	print $filehandle  "<h1>", $page->get_title()->format(), "</h1>";
    foreach my $comment ( @{ $page->get_matched() } ) {
        my $username = $comment->get_username();
        print $filehandle
"<div class=\"comment\"><a href=https://news.ycombinator.com/user?id=$username>User: $username</a><br>",
          $comment->get_post()->as_HTML(),
          "\n</div>\n\n";
    }
    print $filehandle "\n\t</BODY>\n</HTML>";
    return scalar @{ $page->get_matched() };
}

sub get_input {
    my @inputarr = @_;
    print join "\n", @inputarr;
    my $input = <>;
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

sub get_code_reference {
	my	( $hash_ref )	= @_;
	return ;
} ## --- end sub get_code_reference

sub option {
    my ($hash_ref) = @_;
    my $coderef = "";
    my @coderefary;
    if ($hash_ref->{help}) { help(); }
    elsif ( $hash_ref->{jobtype} ne "" ) {
        $coderef = GutsyExample::get_subroutine( "jobtype", $hash_ref->{jobtype} );
        if ($coderef) {
            push( @coderefary, $coderef );
        }
        else {
            print "Invalid Job Type\n";
        }
    }
    if ( $hash_ref->{location} ne "" ) {
        $coderef = GutsyExample::get_subroutine( "location", $hash_ref->{location} );
        if ($coderef) {
            push( @coderefary, $coderef );
        }
        else {
            print "Invalid Location\n";
        }
    }
    if ( $hash_ref->{proglang} ne "" ) {
        $coderef = GutsyExample::get_subroutine( "proglang", $hash_ref->{proglang} );
        if ($coderef) {
            push( @coderefary, $coderef );
        }
        else {
            print "Invalid Programming Language\n";
        }
    }
    if ( !scalar @coderefary ) {
        print "default search all entries\n\n";
        $coderef = GutsyExample::returnAll();
        push( @coderefary, $coderef ) if $coderef;
    }
    if ( !$hash_ref->{url} ) {
        $hash_ref->{url} = "https://news.ycombinator.com/item?id=8542892";    #november 2014
        print "no url included: using default $hash_ref->{url}\n";
    }
    if ($hash_ref->{search}) {
        push( @coderefary, search($hash_ref->{search}) );
        print "searching for $hash_ref->{search}\n";
    }    #use search term

    my $page            = GutsyPage->new_complete_url($hash_ref->{url});
    my $comment_success = $page->match_comments( \@coderefary );
    my $filename;
    unless ($comment_success) {
        print "no comments found, aborting printing to file\n";
        return;
    }
    if ($hash_ref->{text}) {
        $filename = $hash_ref->{file} || "out.txt";
        open( my $filehandle, ">", $filename ) or die "$! can't open file";
        print_to_text_file( $page, $filehandle );
        close $filehandle;
    }
    else {
        $filename = $hash_ref->{file} || "out.html";
        open( my $filehandle, ">", $filename ) or die "$! can't open file";
        print_to_html( $page, $filehandle );
        close $filehandle;
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

sub search {
    my $pattern = shift;
    my $regex = eval { qr/$pattern/ };
    die "invalid search pattern $@" if $@;
    return sub {
        my $post = shift;
        return ( $post && $post->get_post()->format() =~ /$regex/i )
          ? 1
          : 0;
      }
}

1;
