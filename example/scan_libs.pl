#!perl -w

use strict;
use warnings::method;

use Module::CoreList;

unless(@ARGV){
	print "Usage: $0 PERL-VERSION\n";
	exit;
}

my $version = shift @ARGV;

my $inc = join '|', map{ quotemeta } @INC;

$SIG{__WARN__} = sub{
	my $msg = join '', @_;

	$msg =~ s{^Method\s+}{};
	$msg =~ s{at (?:$inc)/(\S+\.pm) line}{at $1 line}o;

	warn $msg;
};

foreach my $mod(sort keys %{$Module::CoreList::version{$version}}){
	next if $mod =~ /^CGI::/;   # CGI::Carp
	next if $mod =~ /^thread/i; # loading order dependency
	next if $mod =~ /^CPAN/;    # too large
	next if $mod =~ /^Devel/;   # DB::DB redefinition

	eval qq{require $mod;};
}
