package Perinci::Script::Plugin::GetResult::FromFunction;

# DATE
# VERSION

use strict 'subs', 'vars';
use warnings;

sub hookmeta_get_result {
    +{
        priority => 50,
    };
}

sub hook_get_result {
    my ($self, $r) = @_;

    my ($mod, $func) = $self->{function} =~ /(.+)::(.+)/;
    (my $mod_pm = "$mod.pm") =~ s!::!/!g;
    require $mod_pm;

    #use DD; dd {mod=>$mod, func=>$func};
    $r->{result} = [200, "OK", "A dummy result"];
    #$r->{result} = \&{"$mod\::$func"}->();
    [100];
}

1;
# ABSTRACT:
