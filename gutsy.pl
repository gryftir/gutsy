#!/usr/bin/env perl
use warnings;
use strict;
use GutsyInterface;
use Getopt::Long;

my (
    $jobtype, $location, $proglang, $url, $number,
    $file,    $text,     $help,     $search
) = ( "", "", "", "", "", "", "", "", "" );
GetOptions(
    "j|jobtype=s"  => \$jobtype,
    "l|location=s" => \$location,
    "p|proglang=s" => \$proglang,
    "u|url=s"      => \$url,
    "n|number=i"   => \$number,
    "h|help"       => \$help,
    "f|file=s"     => \$file,
    "t|text"       => \$text,
    "s|search=s"   => \$search
);

my @optionarr = (
    $jobtype, $location, $proglang, $url, $number,
    $file,    $text,     $help,     $search
);
GutsyInterface::option( \@optionarr );

