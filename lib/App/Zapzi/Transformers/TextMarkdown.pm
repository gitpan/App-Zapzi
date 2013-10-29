package App::Zapzi::Transformers::TextMarkdown;
# ABSTRACT: transform text using Markdown


use utf8;
use strict;
use warnings;

our $VERSION = '0.012'; # VERSION

use Carp;
use Encode;
use Text::Markdown;
use Moo;

with 'App::Zapzi::Roles::Transformer';


sub name
{
    return 'TextMarkdown';
}


sub handles
{
    my $self = shift;
    my $content_type = shift;

    return 1 if $content_type =~ m|text/plain|;
}


sub transform
{
    my $self = shift;

    my $raw = Encode::decode_utf8($self->input->text);

    # Chop off any blank lines at the top
    $raw =~ s/^\n+//s;

    # We take the first line as the title, or up to 80 bytes
    $self->_set_title( (split /\n/, $raw)[0] );
    $self->_set_title(substr($self->title, 0, 80));

    # We push plain text through Markdown to convert URLs to links etc
    my $md = Text::Markdown->new;
    $self->_set_readable_text($md->markdown($raw));

    return 1;
}

1;

__END__

=pod

=head1 NAME

App::Zapzi::Transformers::TextMarkdown - transform text using Markdown

=head1 VERSION

version 0.012

=head1 DESCRIPTION

This class takes text and returns readable HTML using Text::Markdown

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
