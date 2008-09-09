package warnings::method;

use 5.008_001;

use strict;
use warnings;

# register 'method', rather than 'warnings::method'
{
	package # hidden from CPAN indexer
		method;
	use warnings::register;
}

our $VERSION = '0.02';

use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

# re-declaration of built-in methods
sub UNIVERSAL::can     :method;
sub UNIVERSAL::isa     :method;

sub import{
	shift;

	my @args;

	while(defined(my $cmd = shift)){
		if($cmd ne 'FATAL' and  $cmd ne 'NONFATAL'){
			require Carp;
			Carp::croak('Usage: use warnings::method ["FATAL" or "NONFATAL"]');
		}
		else{
			@args = ($cmd => 'method');
		}
	}
	warnings->import(@args ? @args : qw(method));
	return;
}
sub unimport{
	warnings->unimport('method');
	return;
}

1;
__END__

=head1 NAME

warnings::method - Produces warnings if methods are called as functions

=head1 VERSION

This document describes method version 0.02

=head1 SYNOPSIS

    use warnings::method; # or use warnings::method 'FATAL';

    package Foo;
    sub bar :method{
	# ...
    }

    Foo::bar(); # WARN: 'Method Foo::bar() called as a function'
    Foo->bar(); # OK

=head1 DESCRIPTION

This pragmatic module produces warnings if methods are called as functions.
Here, I<methods> are subroutines declared with the B<:method> attribute.

This module scans compiled opcode tree, checks subroutine calls and produces
warnings when dangerous function calls are detected. All the processes finish
in compile time, so this module has no effect on run-time behaviors.

The C<UNIVERSAL::isa> and C<UNIVERSAL::can> distributions are modules based on
the same concept, but they produce warnings at run time, in contract to
C<warnings::method>.

See L<UNIVERSAL::isa> and L<UNIVERSL::can> for details.

=head1 INTERFACE

=head2 C<use/no warnings::method;>

Enables/Disables the C<method> warnings. They are equivalent to
C<use/no warnings 'method'> if C<warnings::method> is already loaded.

=head1 DEPENDENCIES

Perl 5.8.1 or later, and a C compiler.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-warnings-method@rt.cpan.org/>, or through the web interface at
L<http://rt.cpan.org/>.

=head1 SEE ALSO

L<UNIVERSAL>.

L<UNIVERSAL::isa>.

L<UNIVERSAL::can>.

=head1 AUTHOR

Goro Fuji E<lt>gfuji(at)cpan.orgE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2008, Goro Fuji E<lt>gfuji(at)cpan.orgE<gt>. Some rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
