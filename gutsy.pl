#!/usr/bin/perl -w
use strict;
use HTML::TreeBuilder;
use GutsyPage;
use GutsyInterface;

my $start_url = "https://news.ycombinator.com/item?id=5803764";
my @pages
  ; #for the More Pages.  Note class="title" 2 on first page q, 1 on intermediate page, none on last page.
my $gutsypage = GutsyPage->new_complete_url($start_url);

my $posts = $gutsypage->match_comments(
    sub {
        my $post = shift;
        if (   $post
            && $post->get_post()->format() =~
            /[[:^alpha:]](intern|internship)[sS]?[[:^alpha:]]/i )
        {
            return 1;
        }
        return 0;
    }
);

GutsyInterface::print_screen($posts);

