package App::Zapzi::Transformers::HTMLExtractMain;
# ABSTRACT: transform text using HTMLExtractMain


use utf8;
use strict;
use warnings;

our $VERSION = '0.009'; # VERSION

use HTML::ExtractMain 0.63;
use Moo;

extends "App::Zapzi::Transformers::HTML";


sub name
{
    return 'HTMLExtractMain';
}


sub handles
{
    my $self = shift;
    my $content_type = shift;

    return 1 if $content_type =~ m|text/html|;
}

# transform and _extract_title inherited from parent

sub _extract_html
{
    my $self = shift;
    my ($raw_html) = @_;

    my $tree = HTML::ExtractMain::extract_main_html($raw_html,
                                                    output_type => 'tree' );

    return $tree;
}

1;

__END__

=pod

=head1 NAME

App::Zapzi::Transformers::HTMLExtractMain - transform text using HTMLExtractMain

=head1 VERSION

version 0.009

=head1 DESCRIPTION

This class takes HTML and returns readable HTML using HTML::ExtractMain.

=head1 METHODS

=head2 name

Name of transformer visible to user.

=head2 handles($content_type)

Returns true if this module handles the given content-type

=head1 AUTHOR

Rupert Lane <rupert@rupert-lane.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Rupert Lane.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
