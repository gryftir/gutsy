package GutsyPage;
use strict;
use warnings;
use HTML::TreeBuilder;
use GutsyComment;

#GutsyPage collects TreeBuilder objects for pages from a Monthly HN Who's Hiring Post


#constructors
sub new_complete_url {
	my ($classname, $url) = @_;
	my $self      = $classname->new_from_url($url);
	$self->{title} = $self->{page}[0]->look_down("_tag", "title")->as_text();
	for ( my $index = 0 ; ( my $next = $self->has_more($index) ) ; $index++ ) {
		my $addurl = "https://news.ycombinator.com" . $next->attr("href");
		$self->add_from_url($addurl);
	}
	return $self;
}


sub new_from_filehandle {
	my ($classname, $filehandle) = @_;
	my $self       = {};
	$self->{page} = [];
	$self->{page}[0] = HTML::TreeBuilder->new_from_file($filehandle);
	$self->{comments}= [];
	close $filehandle;
	bless( $self, $classname );
	$self->make_comments();
	return $self;
}

sub new_from_filename {
	my ($classname, $filename) = @_;
	my $filesave  = ".files/" . $filename;
	open( my $filehandle, "<", $filesave ) or die "$!\n invalid url or failed to download\n";
	return $classname->new_from_filehandle($filehandle) ;
}

sub new_from_url {
	my ($classname, $url, $nocurl) = @_;
	my $self      = {};
	if ( !$nocurl ) {    #if we didn't say don't use curl
		if ( !system("which curl 1> /dev/null") ) {
			my $filename = $classname->download($url);
			$self = $classname->new_from_filename($filename);
		}
		else { die "$!\n no curl on system\n"; }
	}
	else {
		$self->{page}[0] = HTML::TreeBuilder->new_from_url($url);
		$self->{page}[0] || die "$!\n TreeBuilder/LWP::Agent failed\n";
	bless( $self, $classname );
	$self->make_comments();
	}
	$self->{url} = $url;
	bless( $self, $classname );
	return $self;
}

#getters
sub get_page {
	my ($self, $index) = @_;
	$index += 0;	
	return $self->{page}[$index];
}

#returns a reference to the array of GutsyComment objects
sub get_comments {
	my $self = shift;
	return $self->{comments};
}

#returns original url
sub get_url {
	my $self = shift;
	return $self->{url};
}

#page title
sub get_title {
	my $self=shift;
	return $self->{title};
}

#utility functions

sub make_comments {
	my $self = shift;
	my $count = 0;
	foreach my $page ( @{ $self->{page} } ) {	
		next if $self->{index}[$count++]; # skip if we already read that page
		my $commentarray = GutsyComment->new($page->look_down( "_tag", "img", "width", "0", "src", "s.gif" ));
		if ($commentarray) {push (@{$self->{comments}}, @$commentarray);}
		$self->{index}[$count - 1] = 1;
	}
	print scalar @{$self->{comments}}, "#\n";
}

sub match_comments {
	my ($self, $functions )  = @_;
	my @array = (@{$self->{comments}});
die "$!\n match comments null object or function\n" unless ($self && $functions);
foreach my $function (@$functions) {	
	my @tempary;
	foreach my $post (@array) {
		if ($function->($post ) ) {
				push( @tempary, $post );
			}
		}
		@array = @tempary;
	}
	return \@array;
}


sub has_more {
	my $self = shift;
	my $index = shift || "0";
	print "more\n" if $self->{page}[$index]
	->look_down( "_tag" => "a", "href" => qr/^\/x\?.*/ );
	return $self->{page}[$index]
	->look_down( "_tag" => "a", "href" => qr/^\/x\?.*/ );
}

sub download {
	my ($classname, $url) = @_;
	mkdir(".files") unless -d ".files";
	$url =~ /(\w+)$/;
	my $filesave = ".files/" . $1 . ".html";
	print "Downloading $url ...\n";
	system("curl --silent $url -o $filesave") == 0
		or die "$!\n curl failed\n";
	return $1 . ".html";
}

sub add_from_url {
	my ($self, $url) = @_;
	my $filename = GutsyPage->download($url);
	my $filesave = ".files/" . $filename;
	open( my $filehandle, "<", $filesave ) or die "$!\n";
	push @{ $self->{page} }, HTML::TreeBuilder->new_from_file($filehandle);
	$self->make_comments();
}

1;
