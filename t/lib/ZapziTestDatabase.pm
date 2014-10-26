#!perl
package ZapziTestDatabase;

use Test::Most;
use File::Temp ();
use App::Zapzi;

sub get_test_app
{
    # Get a temporary directory for output of eBooks and an in-memory
    # database to speed up testing

    my $test_dir = _get_test_dir();
    my $dir = "$test_dir/zapzi";

    my $app = App::Zapzi->new(test_database => 1, zapzi_dir => $dir);
    $app->init();
    ok( ! $app->run, 'Created test Zapzi instance' );

    return ($test_dir, $app);
}

sub test_init
{
    # For init we need a database disk file to show that dropping the
    # database and recreating it works.

    my $test_dir = _get_test_dir();
    my $dir = "$test_dir/zapzi";

    my $app = App::Zapzi->new(test_database => 0, 
                              zapzi_dir => '');
    $app->process_args('init');
    ok( $app->run, 'Detect empty directory on init' );

    $app = App::Zapzi->new(test_database => 0, zapzi_dir => $dir);

    $app->process_args('ls');
    ok( $app->run, 'Commands cannot be run before init' );

    $app->init();
    ok( ! $app->run, 'Created test Zapzi instance 2' );

    $app->process_args('init');
    ok( $app->run, 'init cannot be run twice' );

    $app->process_args('init', '--force');
    ok( ! $app->run, 'init can be re-run with force option' );
}

sub _get_test_dir
{
    return File::Temp->newdir("zapzi-XXXXX", TMPDIR => 1);
}

1;
