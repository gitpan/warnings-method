#!perl
use FindBin qw($Bin);
use lib $Bin;

use warnings::method;
use warnings;
sub say{ print @_, "\n" }

use Foo;

my $foo = Foo->new();           # OK
$foo->bar('Called as methods'); # OK
say $foo->bar();                # OK

$foo = Foo::new('Foo');                # WARN
Foo::bar($foo, 'Called as functions'); # WARN
say Foo::bar($foo);                    # WARN

{
	no warnings::method;

	$foo = Foo::new('Foo');                # OK
	Foo::bar($foo, 'Called as functions'); # OK
	say Foo::bar($foo);                    # OK

}
