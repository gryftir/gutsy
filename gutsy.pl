#!/usr/bin/perl -w
use strict;
use LWP::Simple;
use Getopt::Long;

my $localfile = 'aprilhiring.html';
my $url = 'https://news.ycombinator.com/item?id=5472746';
my $savefile = 'results.txt';
my $uselocal = 0;
my $debug = 0;
GetOptions(
	"u|url=s" => \$url,
"f|filename=s" => \$localfile,
	"r|results=s"=> \$savefile,
	"l|local" => \$uselocal
);

my $response = getstore ($url, $localfile) unless $uselocal;
print "$localfile\t$url\t$response\n" if $debug;

open (my $filehandle, "<", $localfile) or die "$!\n";

my @lines = <$filehandle>;
close ($filehandle);
my $savefileref;
if (!$debug)
{
	open ($savefileref, ">", $savefile) or die "$! $savefile\n";
}
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
				if ($debug){print "$user_url\n";}
				else {print $savefileref "$user_url\n";}
			}
			if ($debug){print "$intern\n\n";}
			else {print $savefileref "$intern\n\n";} 	
		}
	}
}
close $savefileref unless $debug;
