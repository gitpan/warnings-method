#!perl -w

use strict;
use Test::More tests => 10;

use warnings::method ();

our $nwarns;

BEGIN{
	my $msg_re = qr/Method \s+ \S+ \s+ called \s+ as \s+ a \s+ function/xms;

	$SIG{__WARN__} = sub{
		my $msg = join '', @_;

#		diag $msg;

		if($msg =~ /$msg_re/xms){
			$nwarns++;
			return;
		}

		warn $msg;
	};
}

is $nwarns, 2, 'warned in compile time';

{
	package A;
	sub foo :method{
		'foo';
	}
	sub bar {
		'bar';
	}
}

{
	use warnings::method;

	is(A::foo(), 'foo', 'A::foo() called as a function (nwarns++)');
	is(A->foo(), 'foo', 'A->foo() called as a method');

	is(A::bar(), 'bar', 'A::bar() called as a function');
	is(A->bar(), 'bar', 'A->bar() called as a method');

}

{
	no warnings::method;

	is(A::foo(), 'foo', 'A::foo() called as a function');
	is(A->foo(), 'foo', 'A->foo() called as a method');

	is(A::bar(), 'bar', 'A::bar() called as a function');
	is(A->bar(), 'bar', 'A->bar() called as a method');
}


is(&A::foo, 'foo', 'under -w (nwarns++)');
