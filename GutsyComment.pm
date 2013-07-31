package GutsyComment;
use strict;
use warnings;

#creates information for each top level comment
sub new {
	my $classname = shift;
	return undef unless scalar @_;
	my $posts = \@_;
	my $comarrayref=[];
	foreach my $post (@$posts) {
		next unless $post;
		my @line = 	$post->lineage();
		my $right =$line[0]->right();
		if ($right) {
		my $comment = {};
			$comment->{user} = $right->right()->look_down( "_tag", "a", "href", qr/^user?/ );
			next unless $comment->{user};
       $comment->{user}->attr("href") =~ /^user\?id=(.*)/;
			 $comment->{username} = $1;
			 $comment->{post} = $comment->{user}->look_up( "_tag", "td" )->look_down( "_tag", "font" );
			 bless ($comment, $classname);
				push (@$comarrayref, $comment);
		}
	}
	return $comarrayref;
}

#getters

sub get_user {
	my $self = shift;
	return $self->{user};
}
sub get_username {
	my $self = shift;
	return $self->{username};
}

sub get_post {
	my $self = shift;
	return $self->{post};
}


1;
