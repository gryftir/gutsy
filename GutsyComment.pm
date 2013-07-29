package GutsyComment;
use HTML::TreeBuilder;
use strict;
use warnings;

#creates information for each top level comment
sub new {
	my $classname = shift;
	return undef unless scalar @_;
	my $posts = \@_;
	my $comarrayref=[];
	foreach my $post (@$posts) {
		my $right = 	$post->lineage()->[0]->right()->right();
		if ($right) {
		my $comment = {};
			$comment->{user} = $right->right()->look_down( "_tag", "a", "href", qr/^user?/ );
       $comment->{user}->attr("href") =~ /^user\?id=(.*)/;
			 $comment->{username} = $1;
			 $comment->{post} = $comment->{user}->look_up( "_tag", "td" )->look_down( "_tag", "font" );
        print "\nuser ", $1, "\n\n";
				push (@$comarrayref, $comment);
		}
	}
	return $comarrayref;
}
1;
