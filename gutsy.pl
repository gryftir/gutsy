#!/usr/bin/perl -w
use strict;
use HTML::TreeBuilder;
use GutsyPage;
my $start_url = "https://news.ycombinator.com/item?id=6310234";
my @pages
  ; #for the More Pages.  Note class="title" 2 on first page q, 1 on intermediate page, none on last page.
my $gutsypage = GutsyPage->new_complete_url($start_url);

my $posts = $gutsypage->match_comments(
    sub {
        my $post = shift;
        if (   $post
            && $post->{post}->format() =~
            /[[:^alpha:]](intern|internship)[sS]?[[:^alpha:]]/i )
        {
            return 1;
        }
        return 0;
    }
);
foreach my $post (@$posts) {
    print "\nuser ", $post->{username}, "\n\n";
    print $post->{post}->format(), "\n";
}

