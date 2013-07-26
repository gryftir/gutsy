package GutsyPage;
use strict;
use warnings;
use HTML::TreeBuilder;

#GutsyPage collects TreeBuilder objects for pages from a Monthly HN Who's Hiring Post
sub match_comments {
    my $self     = shift;
    my $function = shift;
    my $arrayref = [];
    foreach my $page ( @{ $self->{page} } ) {
        my @temparray =
          $page->look_down( "_tag", "img", "width", "0", "src", "s.gif" );
        foreach my $post (@temparray) {
            if ($post &&  $function->($post) ) {
                push( @$arrayref, $post );
            }
        }
    }
    return $arrayref;
}

sub new_complete_url {
    my $classname = shift;
    my $url       = shift;
    my $self      = GutsyPage->new_from_url($url);
    for ( my $index = 0 ; ( my $next = $self->has_more($index) ) ; $index++ ) {
        my $addurl = "https://news.ycombinator.com" . $next->attr("href");
        $self->add_from_url($addurl);
    }
		return $self;
}

sub has_more {
    my $self = shift;
    my $index = shift || "0";
    return $self->{page}[$index]
      ->look_down( "_tag" => "a", "href" => qr/^\/x\?.*/ );
}

sub download {
    my $classname = shift;
    my $url       = shift;
    mkdir(".files") unless -d ".files";
    $url =~ /(\w+)$/;
    my $filesave = ".files/" . $1 . ".html";
    system("curl --silent $url -o $filesave") == 0
      or die "$!\n curl failed\n";
    return $1 . ".html";
}

sub add_from_url {
    my $self     = shift;
    my $url      = shift;
    my $filename = GutsyPage->download($url);
    my $filesave = ".files/" . $filename;
    open( my $filehandle, "<", $filesave ) or die "$!\n";
    push @{ $self->{page} }, HTML::TreeBuilder->new_from_file($filehandle);

}

sub new_from_filehandle {
    my $classname  = shift;
    my $filehandle = shift;
    my $self       = {};
    $self->{page} = [];
    $self->{page}[0] = HTML::TreeBuilder->new_from_file($filehandle);
    bless( $self, $classname );
    return $self;
}

sub new_from_filename {
    my $classname = shift;
    my $filename  = shift;
    my $filesave  = ".files/" . $filename;
    open( my $filehandle, "<", $filesave ) or die "$!\n";
    my $self = {};
    $self->{page} = [];
    $self->{page}[0] = HTML::TreeBuilder->new_from_file($filehandle);
    close($filehandle);
    bless( $self, $classname );
    return $self;
}

sub new_from_url {
    my $classname = shift;
    my $url       = shift;
    my $nocurl    = shift;
    my $self      = {};
    if ( !$nocurl ) {    #if we didn't say don't use curl
        if ( !system("which curl 1> /dev/null") ) {
            my $filename = GutsyPage->download($url);

            $self = GutsyPage->new_from_filename($filename);
        }
        else { die "$!\n no curl on system\n"; }
    }
    else {
        $self->{page} = HTML::TreeBuilder->new_from_url($url);
        $self->{page} || die "$!\n TreeBuilder/LWP::Agent failed\n";
    }
    $self->{url} = $url;
    bless( $self, $classname );
    return $self;
}

1;
