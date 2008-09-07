package
	Foo;

use Moose;

BEGIN{
	has bar => (is => 'rw');
}

sub bar :method;

sub new :method{
	my $class = shift;
	$class->SUPER::new(@_);
}

1;
