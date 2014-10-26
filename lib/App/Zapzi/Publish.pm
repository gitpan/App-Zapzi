package App::Zapzi::Publish;
# ABSTRACT: create eBooks from Zapzi articles


use utf8;
use strict;
use warnings;

our $VERSION = '0.001'; # VERSION

use Carp;
use Encode;
use App::Zapzi;
use DateTime;
use EBook::MOBI;
use Moo;


has folder => (is => 'ro', required => 1);


has filename => (is => 'rwp');


sub publish
{
    my $self = shift;

    $self->_make_filename();
    unlink($self->filename);

    my $book = EBook::MOBI->new();
    $book->set_filename($self->filename);
    $book->set_title($self->_get_title);
    $book->set_author('Zapzi');
    $book->set_encoding(':encoding(UTF-8)');
    $book->add_toc_once();
    $book->add_mhtml_content("<hr>\n");

    my $articles = App::Zapzi::Articles::get_articles($self->folder);
    while (my $article = $articles->next)
    {
        $book->add_mhtml_content("<h1>" . $article->title . "</h1>\n");
        $book->add_mhtml_content($article->article_text->text);
        $book->add_pagebreak();
        App::Zapzi::Articles::move_article($article->id, 'Archive')
            unless $self->folder eq 'Archive';
    }

    $book->make();
    $book->save();

    return -s $self->filename;
}

sub _get_title
{
    my $self = shift;

    my $dt = DateTime->now;
    return sprintf("%s - %s", $self->folder, $dt->strftime('%d-%b-%Y'));
}


sub _make_filename
{
    my $self = shift;
    my $app = App::Zapzi::get_app();

    my $base = sprintf("Zapzi - %s.mobi", $self->_get_title);

    $self->{filename} = $app->zapzi_ebook_dir . "/" . $base;
}

1;

__END__

=pod

=head1 NAME

App::Zapzi::Publish - create eBooks from Zapzi articles

=head1 VERSION

version 0.001

=head1 DESCRIPTION

This class takes a collection of cleaned up HTML articles and creates eBooks.

This interface is temporary to get the initial version of Zapzi
working and will be replaced with a more flexible role based system
later.

=head1 ATTRIBUTES

=head2 folder

Folder of articles to publish

=head2 filename

File that the published ebook is stored in.

=head1 METHODS

=head2 publish

Publish an eBook in MOBI format to the ebook directory.

=head1 AUTHOR

Rupert Lane <rupert@rupert-lane.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Rupert Lane.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
