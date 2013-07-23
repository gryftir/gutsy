package GutsyPage;
use strict;
use warnings;
use HTML::TreeBuilder;

sub download {
	my $classname = shift;
	my $url = shift;
	mkdir (".files", "0755") unless -d ".files";
	$url =~ /(\w+)$/;
	system("curl", "--silent", $url, "-o", ".files/$1") == 0 or die "$!\n curl failed\n";
}


sub new_from_filehandle {
	my $classname = shift;
	my $filehandle = shift;
	my $self = {};
	$self->{page} = HTML::TreeBuilder->new_from_file($filehandle);
	bless($self, $classname);
	return $self;
}
sub new_from_filename {
	my $classname = shift;
	my $filename = shift;
	open (my $filehandle, "<", $filename) or die "$!\n";
	my $self = {};
	$self->{page} = HTML::TreeBuilder->new_from_file($filehandle);
	close($filehandle);
	bless($self, $classname);
	return $self;
}

sub new_from_url {
	my $classname = shift;
	my $url = shift;
	my $nocurl = shift;
	my $self = {};
	if (!$nocurl ) { #if we didn't say don't use curl
		if (  system("which curl 1> /dev/null")	) {
			GutsyPage->download($url);
			$self = GutsyPage->new_from_file($1);	
		}
		else {die "$!\n no curl on system\n";}
	}
	else {
		$self->{page} = HTML::TreeBuilder->new_from_url($url); 
		$self->{page} || die "$!\n TreeBuilder/LWP::Agent failed\n";
	}
	$self->{url} = $url;
	bless($self,$classname);
	return $self;
}


1;
