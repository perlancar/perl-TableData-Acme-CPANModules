package ## no critic: Modules::RequireFilenameMatchesPackage
    # hide from PAUSE
    TableDataRole::Acme::CPANModules;

use 5.010001;
use strict;
use warnings;

use Role::Tiny;
with 'TableDataRole::Source::AOA';

around new => sub {
    my $orig = shift;
    my ($self, %args) = @_;

    my $ac_module = delete $args{module}
        or die "Please specify 'module' argument";
    $ac_module =~ s/\AAcme::CPANModules:://;
    my $list = do {
        my $module = "Acme::CPANModules::$ac_module";
        (my $module_pm = "$module.pm") =~ s!::!/!g;
        require $module_pm;
        no strict 'refs'; ## no critic: TestingAndDebugging::ProhibitNoStrict
        ${"$module\::LIST"};
    };

    my $aoa = [];
    my $column_names = [qw/
                              module
                              script
                              summary
                              description
                              rating
                          /];
    for my $entry (@{ $list->{entries} }) {
        push @$aoa, [
            $entry->{module},
            $entry->{script},
            $entry->{summary},
            $entry->{description},
        ];
    }

    $orig->($self, %args, aoa => $aoa, column_names=>$column_names);
};

package TableData::Acme::CPANModules;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Acme::CPANModules';

# STATS

1;
# ABSTRACT: Entries from a Acme::CPANModules::* module

=head1 SYNOPSIS

Using from the CLI:

 % tabledata Acme/CPANModules=module,WorkingWithCSV


=head1 DESCRIPTION

A quick way to list the entries in an C<Acme::CPANModules::*> module in table
form. For a more proper way, see L<cpanmodules> CLI.


=head1 METHODS

=head2 new

Usage:

 my $table = TableData::Acme::CPANModules->new(%args);

Known arguments:

=over

=item * module

Required.

=back
