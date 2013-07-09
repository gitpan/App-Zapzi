package App::Zapzi::Database::Schema;
# ABSTRACT: database schema for zapzi

use utf8;
use strict;
use warnings;

our $VERSION = '0.004'; # VERSION

use base 'DBIx::Class::Schema';

# Load Result classes under this schema
__PACKAGE__->load_classes(qw/Article ArticleText Folder/);

1;

__END__

=pod

=head1 NAME

App::Zapzi::Database::Schema - database schema for zapzi

=head1 VERSION

version 0.004

=head1 AUTHOR

Rupert Lane <rupert@rupert-lane.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Rupert Lane.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
