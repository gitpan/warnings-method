use strict;
use warnings;
use inc::Module::Install;

name 'warnings-method';

all_from 'method.pm';

WriteMakefile(
	clean => {FILES => 'warnings-method-* *.gcov *.gcda *.gcno *.stackdump'},
);
