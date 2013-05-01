#!/usr/bin/perl -w
use strict;
use LWP::Simple;
use Getopt::Long;

#variable declarations
my $localfile = 'aprilhiring.html';
my $url = 'https://news.ycombinator.com/item?id=5472746'; #may 2013
my $savefile = 'results.txt';
my $uselocal = 0;
#debug, prints stuff, but doesn't save results, just prints to screen
my $debug = 0;
my $usecurl = 0;

#read in command line options
GetOptions(
	"u|url=s" => \$url,
	"f|filename=s" => \$localfile,
	"r|results=s"=> \$savefile,
	"l|local" => \$uselocal,
	"c|curl" => \$usecurl,
);
#use curl, useful because LWP requires a separate module for https connections
if ($usecurl){

	system ("curl -o ", $localfile, $url) == 0 or die "$!\n curl failed\n";
}
#download with perl unless using a local file
else {
my $response = getstore ($url, $localfile) unless $uselocal;

print "$localfile\t$\n" if $debug;
}

#open the local/downloaded file
open (my $filehandle, "<", $localfile) or die "$!\n Perl LWP::Simple may have failed if you lack Crypt:SSLeay\n (try -c option)\n";

#read in the file into an array  
#Potentially memory issues here for bigger files but ok here
my @lines = <$filehandle>;
close ($filehandle);
my $savefileref;
if (!$debug)
{
	open ($savefileref, ">", $savefile) or die "$! $savefile\n";
}
#join on <p>, because we want one big string, and because we replace
#<p> with new lines later anyway
my $file = join '<p>', @lines;
#this splits on tot level comments. width for comments is used to distinguish
@lines = split '<img src="s.gif" height=1 width=0>', $file;
#for each string, which starts with a top level comment
foreach my $entry (@lines){
#get the text of the comment	
	if( $entry =~ /<span class="comment"><font color=#000000>(.+?)<\/font><\/span>(.*)/i){
		my $intern = $1;
#test for an internship related word		
		if ($intern =~ /\b(intern|internship|interns|interships)\b/i){
#replace <p> with new lines
			$intern =~ s/<p>/\n/gi;
#get user name and print HN link to them
			if ($entry =~ /<a href="user\?id=(.+?)">/i){
				my $user_url = $1;
				$user_url = 'USER: http://news.ycombinator.com/user?id=' . $user_url;
				if ($debug){print "$user_url\n";}
				else {print $savefileref "$user_url\n";}
			}
#print the text string.  could be cleaned up more, to parse out e-mails/addresses for example			
			if ($debug){print "$intern\n\n";}
			else {print $savefileref "$intern\n\n";} 	
		}
	}
}
close $savefileref unless $debug;
