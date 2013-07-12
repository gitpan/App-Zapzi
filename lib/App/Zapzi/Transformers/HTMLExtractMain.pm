package App::Zapzi::Transformers::HTMLExtractMain;
# ABSTRACT: transform text using HTMLExtractMain


use utf8;
use strict;
use warnings;

our $VERSION = '0.005'; # VERSION

use Carp;
use Encode;
use HTML::ExtractMain 0.63;
use HTML::Element;
use HTML::Entities ();
use Moo;

with 'App::Zapzi::Roles::Transformer';


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


sub transform
{
    my $self = shift;

    my $encoding = 'utf8';
    if ($self->input->content_type =~ m/charset=([\w-]+)/)
    {
        $encoding = $1;
    }
    my $raw_html = Encode::decode($encoding, $self->input->text);

    # Get the title from the HTML raw text - a regexp is not ideal and
    # we'd be better off using HTML::Tree but that means we'd have to
    # call it twice, once here and once in HTML::ExtractMain.
    my $title;
    if ($raw_html =~ m/<title>(\w[^>]+)<\/title>/si)
    {
        $title = HTML::Entities::decode($1);
    }
    else
    {
        $title = $self->raw_article->source;
    }

    $self->_set_title($title);

    my $tree = HTML::ExtractMain::extract_main_html($raw_html,
                                                    output_type => 'tree' );

    return unless $tree;

    # Delete some elements we don't need
    for my $element ($tree->find_by_tag_name(qw{img script noscript object}))
    {
        $element->delete;
    }

    # Set up options to extract the HTML from the tree
    my $entities_to_encode = undef; # ie encode all entities
    my $indent = ' ' x 4;
    my $optional_end_tags = {};

    $self->_set_readable_text($tree->as_HTML($entities_to_encode, $indent,
                                             $optional_end_tags));
    return 1;
}

1;

__END__

=pod

=head1 NAME

App::Zapzi::Transformers::HTMLExtractMain - transform text using HTMLExtractMain

=head1 VERSION

version 0.005

=head1 DESCRIPTION

This class takes HTML and returns readable HTML using HTML::ExtractMain.

=head1 METHODS

=head2 name

Name of transformer visible to user.

=head2 handles($content_type)

Returns true if this module handles the given content-type

=head2 transform

Converts L<input> to readable text. Returns true if converted OK.

=head1 AUTHOR

Rupert Lane <rupert@rupert-lane.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Rupert Lane.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut