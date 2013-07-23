package Gutsypage;
use strict;
use warnings;
use HTML::TreeBuilder;


sub new_from_file {
	my $classname = shift;
	my $filename = shift;
	my $filehandle;
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
	my $hascurl;
	my $self {};
	if (!$nocurl ) {
		if (  system("which curl 1> /dev/null")	) {
			$url =~ /(\d+)$/
			system("curl", "--silent", $url, "-o", $1) == 0 or die "$!\n curl failed\n";
			$self = gutsypage->new_from_file($1);	
			bless($self,$classname);
		}
		else {die "$!\n no curl on system\n";}
	}
	else {
		$self->{page} = HTML::TreeBuilder->new_from_url($url) 
	}
$self->{url} = $url;
return $self;
}


1;
