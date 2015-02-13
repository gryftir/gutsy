package GutsyExample;
use strict;
use warnings;

sub get_subroutine {
    my ( $type, $value ) = @_;
    my %codehash;
    $codehash{"jobtype"}  = {};
    $codehash{"location"} = {};
    $codehash{"proglang"} = {};

    $codehash{"jobtype"}{"intern"}     = \&internref;
    $codehash{"jobtype"}{"h1b"}        = \&h1bref;
    $codehash{"jobtype"}{"remote"}     = \&remoteref;
    $codehash{"jobtype"}{"entrylevel"} = \&entrylevelref;

    $codehash{"location"}{"sfbay"}     = \&sfbayref;

    $codehash{"proglang"}{"perl"}      = \&perlref;
    $codehash{"proglang"}{"ruby"}      = \&rubyref;
    $codehash{"proglang"}{"python"}    = \&pythonref;
    $codehash{"proglang"}{"c"}         = \&cref;

    my $returnval =
      defined $codehash{$type}{ lc $value } ? $codehash{$type}{$value} : 0;
    print "Using $value search for $type\n" if $returnval;
    return $returnval;
}

#=============================================================================
#return all
sub returnAll {
    return sub { return 1; }
}

#jobtypes

#interns
sub internref {
    my $post = shift;
    return ( $post
          && $post->get_post()->format() =~
          /[[:^alpha:]](intern|internship)[sS]?[[:^alpha:]]/ix ) ? 1 : 0;
}

#hib

sub h1bref {
    my $post = shift;
    return ( $post
          && $post->get_post()->format() =~ /h1-?b|visa/ix
          && !( $post->get_post()->format() =~ /(no|not)\s*(hib|visa)/ix ) )
      ? 1
      : 0;
}

#remote
sub remoteref {
    my $post = shift;
    return (
             $post
          && $post->get_post()->format() =~
          /remote|you\s+can\s+be\s+anywhere|work
\s*from\s*(home|anywhere)|distributed\s+team/ix
          && !(
            $post->get_post()->format() =~
            /(no|not)\s*remote|remote\s*control|can't\s*accept\s*remote/ix
          )
    ) ? 1 : 0;
}

#entrylevel

sub entrylevelref {
    my $post = shift;
    return ( $post
          && $post->get_post()->format() =~ /entry|junior/ix
          && !( $post->get_post()->format() =~ /not\s+an\s+entry/ix ) ) ? 1 : 0;
}

#=============================================================================
#location

#sf bay area
sub sfbayref {
    my $post = shift;
    return (
             $post
          && $post->get_post()->format() =~
          /san\s*francisco|palo\s*alto|san\s*jose|[[:^alpha:]]
	sj|mountain\s*view|cupertino|sunnyvale|santa\s*clara|
	downtown\s*mv|[[:^alpha:]]sf[[:^alpha:]]|berkeley|oakland
	|fremont|stanford|sf\s*bay|san\s*mateo|alameda/ix
    ) ? 1 : 0;
}

#=============================================================================
#Perl
sub perlref {
    my $post = shift;
    return ( $post && $post->get_post()->format() =~ /perl(?!y)/ix ) ? 1 : 0;
}

#ruby
sub rubyref {
    my $post = shift;
    return ( $post && $post->get_post()->format() =~ /ruby|rails/ix ) ? 1 : 0;
}

#python
sub pythonref {
    my $post = shift;
    return ( $post && $post->get_post()->format() =~ /python|django/ix )
      ? 1
      : 0;
}

#C 
sub cref {
    my $post = shift;
    return ($post && $post->get_post()->format() =~ /\sc\s/ix)
      ? 1
      : 0;
}

1;
