use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.033

use Test::More  tests => 21 + ($ENV{AUTHOR_TESTING} ? 1 : 0);



my @module_files = (
    'App/Zapzi.pm',
    'App/Zapzi/Articles.pm',
    'App/Zapzi/Config.pm',
    'App/Zapzi/Database.pm',
    'App/Zapzi/Database/Schema.pm',
    'App/Zapzi/Database/Schema/Article.pm',
    'App/Zapzi/Database/Schema/ArticleText.pm',
    'App/Zapzi/Database/Schema/Config.pm',
    'App/Zapzi/Database/Schema/Folder.pm',
    'App/Zapzi/FetchArticle.pm',
    'App/Zapzi/Fetchers/File.pm',
    'App/Zapzi/Fetchers/POD.pm',
    'App/Zapzi/Fetchers/URL.pm',
    'App/Zapzi/Folders.pm',
    'App/Zapzi/Publish.pm',
    'App/Zapzi/Publishers/EPUB.pm',
    'App/Zapzi/Publishers/HTML.pm',
    'App/Zapzi/Publishers/MOBI.pm',
    'App/Zapzi/Transform.pm',
    'App/Zapzi/UserConfig.pm'
);

my @scripts = (
    'bin/zapzi'
);

# no fake home requested

use File::Spec;
use IPC::Open3;
use IO::Handle;

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    open my $stdin, '<', File::Spec->devnull or die "can't open devnull: $!";
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, '-Mblib', '-e', "require q[$lib]");
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($? >> 8, 0, "$lib loaded ok");

    if (@_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}

foreach my $file (@scripts)
{ SKIP: {
    open my $fh, '<', $file or warn("Unable to open $file: $!"), next;
    my $line = <$fh>;
    close $fh and skip("$file isn't perl", 1) unless $line =~ /^#!.*?\bperl\b\s*(.*)$/;

    my @flags = $1 ? split(/\s+/, $1) : ();

    open my $stdin, '<', File::Spec->devnull or die "can't open devnull: $!";
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, '-Mblib', @flags, '-c', $file);
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($? >> 8, 0, "$file compiled ok");

   # in older perls, -c output is simply the file portion of the path being tested
    if (@_warnings = grep { !/\bsyntax OK$/ }
        grep { chomp; $_ ne (File::Spec->splitpath($file))[2] } @_warnings)
    {
        # temporary measure - win32 newline issues?
        warn map { _show_whitespace($_) } @_warnings;
        push @warnings, @_warnings;
    }
} }

sub _show_whitespace
{
    my $string = shift;
    $string =~ s/\012/[\\012]/g;
    $string =~ s/\015/[\\015]/g;
    $string =~ s/\t/[\\t]/g;
    $string =~ s/ /[\\s]/g;
    return $string;
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};


