#!perl -w

use strict;
use Test::More tests => 5;

ok !eval q{
	use warnings::method 'FATAL';

	UNIVERSAL::isa('UNIVERSAL', 'UNIVERSAL');
}, 'FATAL';
like $@, qr/^Method/, 'die with message';
{
	local $SIG{__WARN__} = sub{};

	ok eval q{
		use warnings::method 'NONFATAL';
		UNIVERSAL::isa('UNIVERSAL', 'UNIVERSAL');
	}, 'NONFATAL';
	if($@){
		diag $@;
	}
}
ok !eval q{
	use warnings::method 'foo';

	UNIVERSAL::isa('UNIVERSAL', 'UNIVERSAL');
}, 'Unknown subdirective';
like $@, qr/^Usage/, 'die with usage';

