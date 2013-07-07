package App::Zapzi::FetchArticle;
# ABSTRACT: routines to get articles for Zapzi


use utf8;
use strict;
use warnings;

our $VERSION = '0.001'; # VERSION

use Carp;
use App::Zapzi;
use Moo;
use HTTP::Tiny;
use HTTP::CookieJar;
use File::MMagic;


has source => (is => 'ro', default => '');


has text => (is => 'ro', default => '');


has content_type => (is => 'ro', default => 'text/plain');


has error => (is => 'ro', default => '');


sub fetch
{
    my $self = shift;

    return -e $self->source ? $self->_fetch_file : $self->_fetch_url;
}

sub _fetch_file
{
    my $self = shift;

    my $file;
    if (! open $file, '<', $self->source)
    {
        $self->error = "Failed to open " . $self->source . ": $!";
        return;
    }

    while (<$file>)
    {
        $self->text .= $_;
    }

    close $file;

    my $mm = new File::MMagic;
    $self->content_type = $mm->checktype_contents($self->text) // 'text/plain';

    return 1;
}

sub _fetch_url
{
    my $self = shift;

    my $jar = HTTP::CookieJar->new;
    my $http = HTTP::Tiny->new(cookie_jar => $jar);

    my $url = $self->source;
    my $response = $http->get($url, $self->_http_request_headers());

    if (! $response->{success} || ! length($response->{content}))
    {
        $self->error = "Failed to fetch $url: ";
        if ($response->{status} == 599)
        {
            # Internal exception to HTTP::Tiny
            $self->error .= $response->{content};
        }
        else
        {
            # Error details from remote server
            $self->error .= $response->{status} . " ";
            $self->error .= $response->{reason};
        }
        return;
    }

    $self->text = $response->{content};
    $self->content_type = $response->{headers}->{'content-type'};

    return 1;
}

sub _http_request_headers
{
    my $self = shift;

    my $ua = "App::Zapzi";

    no strict 'vars'; ## no critic - $VERSION does not exist in dev
    $ua .= "/$VERSION" if defined $VERSION;

    return {headers => {'User-agent' => $ua}};
}

1;

__END__

=pod

=head1 NAME

App::Zapzi::FetchArticle - routines to get articles for Zapzi

=head1 VERSION

version 0.001

=head1 DESCRIPTION

These routines get articles, either via HTTP or from the file system
and returns the raw HTML or text.

This interface is temporary to get the initial version of Zapzi
working and will be replaced with a more flexible role based system
later.

=head1 ATTRIBUTES

=head2 source

Pass in the source of the article - either a filename or a URL.

=head2 text

Holds the raw text of the article

=head2 content_type

MIME content type for text.

=head2 error

Holds details of any errors encountered while retrieving the article;
will be blank if no errors.

=head1 METHODS

=head2 fetch

Retrieves the article and returns 1 if OK. Text of the article can
then be found in L<text>.

=head1 AUTHOR

Rupert Lane <rupert@rupert-lane.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Rupert Lane.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
