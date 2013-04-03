#!/usr/bin/perl -w
use strict;
use LWP::Simple;
use Getopt::Long;

my $localfile = 'aprilhiring.html';
my $url = 'https://news.ycombinator.com/item?id=5472746';

GetOptions(
	"u|url=s" => \$url,
	"f|filename=s" => \$localfile);
my $response = getstore ($url, $localfile);
print "$localfile\t$url\t$response\n";

open (my $filehandle, "<", $localfile) or die "$!\n";


my @lines = <$filehandle>;
my $file = join '<p>', @lines;
@lines = split '<img src="s.gif" height=1 width=0>', $file;
foreach my $entry (@lines){
	if( $entry =~ /<span class="comment"><font color=#000000>(.+?)<\/font><\/span>(.*)/i){
		my $intern = $1;
		if ($intern =~ /\b(intern|zointernship|interns|interships)\b/i){
			$intern =~ s/<p>/\n/gi;
			if ($entry =~ /<a href="user\?id=(.+?)">/i){
				my $user_url = $1;
				$user_url = 'USER: http://news.ycombinator.com/user?id=' . $user_url;
				print "$user_url\n";
		}
			print "$intern\n\n";
			sleep 2;	
		}
	}
}
