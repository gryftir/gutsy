#!/usr/bin/perl -w
use strict;
use HTML::TreeBuilder;
use GutsyPage;
my $start_url = "https://news.ycombinator.com/item?id=5803764";
my @pages
  ; #for the More Pages.  Note class="title" 2 on first page q, 1 on intermediate page, none on last page.
my $gutsypage = GutsyPage->new_complete_url($start_url);

my $posts = $gutsypage->match_comments(sub  {
        my $post = shift;
        my @line = $post->lineage();
        my $user = $line[0]->right();
        if ($user) {
            $user =
              $user->right()->look_down( "_tag", "a", "href", qr/^user?/ );
            my $font =
              $user->look_up( "_tag", "td" )->look_down( "_tag", "font" );
            if (   $font
                && $font->as_text() =~
                /[[:^alpha:]](intern|internship)[sS]?[[:^alpha:]]/i )
            {
                return 1;
            }
        }
        return 0;
			});
foreach my $post (@$posts) {
    my @line = $post->lineage();
    my $user = $line[0]->right();
    if ($user) {
        $user = $user->right()->look_down( "_tag", "a", "href", qr/^user?/ );
        my $font = $user->look_up( "_tag", "td" )->look_down( "_tag", "font" );
        $user->attr("href") =~ /^user\?id=(.*)/;
        print "\nuser ", $1, "\n\n";
        print $font->as_text(), "\n";
			}
		}
	

