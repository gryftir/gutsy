package GutsyComment;
use strict;
use warnings;

#creates comment objects and passes back an array of them
sub new {
    my @posts       = @_;
    my $classname   = shift @posts;
    my $comarrayref = [];
    foreach my $post (@posts) {
        next unless $post;
        my @line         = $post->lineage();
        my $rightElement = $line[0]->right();
        if ($rightElement) {
            my $comment = {};
            $comment->{user} =
              $rightElement->right()
              ->look_down( "_tag", "a", "href", qr/^user?/x );
            next unless $comment->{user};
            $comment->{user}->attr("href") =~ /^user\?id=(?<username>.*)/x;
            $comment->{username} = $+{username};
            $comment->{post} =
              $comment->{user}->look_up( "_tag", "td" )
              ->look_down( "_tag", "font" );
            bless( $comment, $classname );
            push( @$comarrayref, $comment );
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
