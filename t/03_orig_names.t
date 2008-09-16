#!perl -w
use strict;
use Test::More tests => 2;

use warnings::method 'FATAL';
use UNIVERSAL qw(isa);

ok !eval q{
	isa([], 'ARRAY');
};
like $@, qr/Method UNIVERSAL::isa/, 'the original name reported';
