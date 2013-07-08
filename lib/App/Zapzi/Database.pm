package App::Zapzi::Database;
# ABSTRACT: database access for Zapzi


use utf8;
use strict;
use warnings;

our $VERSION = '0.002'; # VERSION

use Moo;
use SQL::Translator;
use App::Zapzi::Database::Schema;


has app => (is => 'ro');


sub database_file
{
    my $self = shift;
    if ($self->app->test_database)
    {
        return ':memory:';
    }
    else
    {
        return $self->app->zapzi_dir . "/zapzi.db";
    }
}


sub dsn
{
    my $self = shift;
    return "dbi:SQLite:dbname=" . $self->database_file;
}

our $_schema;


sub schema
{
    my $self = shift;
    $_schema //= App::Zapzi::Database::Schema->connect({
        dsn =>$self->dsn,
        sqlite_unicode => 1,
        on_connect_do => 'PRAGMA foreign_keys = ON'});
    return $_schema;
}


sub init
{
    my $self = shift;
    mkdir $self->app->zapzi_dir;
    die "Can't access ", $self->app->zapzi_dir 
        if ! -d $self->app->zapzi_dir;
    mkdir $self->app->zapzi_ebook_dir;

    $self->schema->storage->disconnect if $self->app->force;
    unlink $self->database_file unless $self->app->test_database;
    $_schema = undef;

    # Adjust the page size to match the expected blob size for articles
    # http://www.sqlite.org/intern-v-extern-blob.html
    $self->schema->storage->dbh->do("PRAGMA page_size = 8192");

    $self->schema->deploy();

    my @folders = ({id => 100, name => 'Inbox'},
                   {name => 'Archive'});
    $self->schema->populate('Folder', \@folders);

    my @articles = ({title => 'Welcome to Zapzi', folder => 100,
                     article_text => 
                         { text => '<p>Welcome to Zapzi! Please run <pre>zapzi -h</pre> to see documentation.</p>'}});
    $self->schema->populate('Article', \@articles);
}

1;

__END__

=pod

=head1 NAME

App::Zapzi::Database - database access for Zapzi

=head1 VERSION

version 0.002

=head1 DESCRIPTION

This class provides access to the Zapzi database.

=head1 ATTRIBUTES

=head2 app

Link to the App::Zapzi application object.

=head1 METHODS

=head2 database_file

The SQLite file where the database is stored.

=head2 dsn

The DSN used to connect to the SQLite database.

=head2 schema

The DBIx::Class::Schema object for the application.

=head2 init

Initialise the database to a new state.

=head1 AUTHOR

Rupert Lane <rupert@rupert-lane.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Rupert Lane.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
