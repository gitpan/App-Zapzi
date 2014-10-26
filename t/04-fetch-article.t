#!perl
use Test::Most;

use lib qw(t/lib);
use ZapziTestDatabase;

use App::Zapzi;
use App::Zapzi::FetchArticle;

test_can();

my ($test_dir, $app) = ZapziTestDatabase::get_test_app();

test_get_file();
test_get_url();
done_testing();

sub test_can
{
    can_ok( 'App::Zapzi::FetchArticle', qw(text source error fetch) );
}

sub test_get_file
{
    my $f = App::Zapzi::FetchArticle->new(source => 't/testfiles/sample.txt');
    isa_ok( $f, 'App::Zapzi::FetchArticle' );
    ok( $f->fetch, 'Fetch sample text file' );
    like( $f->text, qr/sample text file/, 'Contents of text file OK' );
    is( $f->content_type, 'text/plain', 'Contents are plain text' );

    $f = App::Zapzi::FetchArticle->new(source => 't/testfiles/sample.html');
    isa_ok( $f, 'App::Zapzi::FetchArticle' );
    ok( $f->fetch, 'Fetch sample html file from disk' );
    like( $f->text, qr/qui officia deserunt/, 'Contents of HTML file OK' );
    is( $f->content_type, 'text/html', 'Contents are HTML' );

    $f = App::Zapzi::FetchArticle->new(source => 't/testfiles/nosuchfile.txt');
    isa_ok( $f, 'App::Zapzi::FetchArticle' );
    ok( ! $f->fetch, 'Detects file that does not exist' );
    like( $f->error, qr/Failed/, 'Error reported' );

    $f = App::Zapzi::FetchArticle->new(source =>
                                       't/testfiles/html-fragment.html');
    isa_ok( $f, 'App::Zapzi::FetchArticle' );
    ok( $f->fetch, 'Fetch sample html fragment file from disk' );
    like( $f->text, qr/This should still be treated as/,
          'Contents of HTML fragment file OK' );
    is( $f->content_type, 'text/html', 'Contents of fragment are HTML' );
}

sub test_get_url
{
    my $f = App::Zapzi::FetchArticle->new(source => 'http://example.com/');
    isa_ok( $f, 'App::Zapzi::FetchArticle' );
    ok( $f->fetch, 'Fetch sample URL' );
    like( $f->text, qr/Example Domain/, 'Contents of test URL OK' );
    like( $f->content_type, qr(text/html), 'Contents are HTML' );

    $f = App::Zapzi::FetchArticle->new(source =>
                                       'http://example.iana.org/nonesuch');
    isa_ok( $f, 'App::Zapzi::FetchArticle' );
    ok( ! $f->fetch, 'Detects URL 404' );
    like( $f->error, qr/404/, 'Error reported' );

    $f = App::Zapzi::FetchArticle->new(source =>
                                       'http://no-such-domain-really.com/');
    isa_ok( $f, 'App::Zapzi::FetchArticle' );
    ok( ! $f->fetch, 'Detects host that does not exist' );
    like( $f->error, qr/Failed/, 'Error reported' );

    $f = App::Zapzi::FetchArticle->new(source =>
                                       'http://999.999.999.999/foo');
    isa_ok( $f, 'App::Zapzi::FetchArticle' );
    ok( ! $f->fetch, 'Detects invalid host' );
    like( $f->error, qr/Failed/, 'Error reported' );

    $f = App::Zapzi::FetchArticle->new(source =>
                                       'httpX://google.com/');
    isa_ok( $f, 'App::Zapzi::FetchArticle' );
    ok( ! $f->fetch, 'Detects invalid URI type' );
    like( $f->error, qr/Failed/, 'Error reported' );
}
