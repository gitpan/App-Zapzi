package App::Zapzi::Transform;
# ABSTRACT: routines to transform Zapzi articles to readble HTML


use utf8;
use strict;
use warnings;

our $VERSION = '0.003'; # VERSION

use Carp;
use Encode;
use HTML::ExtractMain;
use HTML::Element;
use HTML::Entities ();
use Text::Markdown;
use App::Zapzi;
use App::Zapzi::FetchArticle;
use Moo;


has raw_article => (is => 'ro', isa => sub
                    {
                        croak 'Source must be an App::Zapzi::FetchArticle'
                            unless ref($_[0]) eq 'App::Zapzi::FetchArticle';
                    });


has readable_text => (is => 'rwp', default => '');


has title => (is => 'rwp', default => '');


sub to_readable
{
    my $self = shift;

    if ($self->raw_article->content_type =~ m|text/html|)
    {
        return $self->_html_to_readable;
    }
    else
    {
        return $self->_text_to_readable;
    }
}

sub _html_to_readable
{
    my $self = shift;

    my $encoding = 'utf8';
    if ($self->raw_article->content_type =~ m/charset=([\w-]+)/)
    {
        $encoding = $1;
    }
    my $raw_html = Encode::decode($encoding, $self->raw_article->text);

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

    $self->_set_readable_text($tree->as_HTML);
    return 1;
}

sub _text_to_readable
{
    my $self = shift;

    my $raw_html = Encode::decode_utf8($self->raw_article->text);

    # We take the first line as the title, or up to 80 bytes
    $self->_set_title( (split /\n/, $raw_html)[0] );
    $self->_set_title(substr($self->title, 0, 80));

    # We push plain text through Markdown to convert URLs to links etc
    my $md = Text::Markdown->new;
    $self->_set_readable_text($md->markdown($raw_html));

    return 1;
}

1;

__END__

=pod

=head1 NAME

App::Zapzi::Transform - routines to transform Zapzi articles to readble HTML

=head1 VERSION

version 0.003

=head1 DESCRIPTION

This class takes text or HTML and returns readable HTML.

This interface is temporary to get the initial version of Zapzi
working and will be replaced with a more flexible role based system
later.

=head1 ATTRIBUTES

=head2 raw_article

Object of type App::Zapzi::FetchArticle to get original text from.

=head2 readable_text

Holds the readable text of the article

=head2 title

Title extracted from the article

=head1 METHODS

=head2 to_readable

Converts L<raw_article> to readable text. Returns true if converted OK.

=head1 AUTHOR

Rupert Lane <rupert@rupert-lane.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Rupert Lane.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
