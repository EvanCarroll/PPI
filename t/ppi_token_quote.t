#!/usr/bin/perl

# Unit testing for PPI::Token::Quote

use lib 't/lib';
use PPI::Test::pragmas;
use Test::More tests => 15 + ($ENV{AUTHOR_TESTING} ? 1 : 0);

use PPI ();


STRING: {
	# Prove what we say in the ->string docs
	my $Document = PPI::Document->new(\<<'END_PERL');
  'foo'
  "foo"
  q{foo}
  qq <foo>
END_PERL
	isa_ok( $Document, 'PPI::Document' );

	my $quotes = $Document->find('Token::Quote');
	is( ref($quotes), 'ARRAY', 'Found quotes' );
	is( scalar(@$quotes), 4, 'Found 4 quotes' );
	foreach my $Quote ( @$quotes ) {
		isa_ok( $Quote, 'PPI::Token::Quote');
		can_ok( $Quote, 'string'		   );
		is( $Quote->string, 'foo', '->string returns "foo" for '
			. $Quote->content );
	}
}
