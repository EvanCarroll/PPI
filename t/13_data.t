#!/usr/bin/perl

# Tests functionality relating to __DATA__ sections of files

use lib 't/lib';
use PPI::Test::pragmas;
use Test::More tests => 7 + ($ENV{AUTHOR_TESTING} ? 1 : 0);

use File::Spec::Functions qw( catfile );
use PPI ();


my $module = catfile('t', 'data', '13_data', 'Foo.pm');
ok( -f $module, 'Test file exists' );

my $Document = PPI::Document->new( $module );
isa_ok( $Document, 'PPI::Document' );

# Get the data token
my $Token = $Document->find_first( 'Token::Data' );
isa_ok( $Token, 'PPI::Token::Data' );

# Get the handle
my $handle = $Token->handle;
isa_ok( $handle, "$]" < 5.008 ? 'IO::String' : 'GLOB' );

# Try to read a line off the handle
my $line = <$handle>;
is( $line, "This is data\n", "Reading off a handle works as expected" );

# Print to the handle
ok( $handle->print("Foo bar\n"), "handle->print returns ok" );
is( $Token->content, "This is data\nFoo bar\nis\n",
	"handle->print modifies the content as expected" );
