package Perinci::Script;

# DATE
# VERSION

use 5.010001;
use strict 'subs', 'vars';
use warnings;
use Log::ger;

sub __plugin_to_pkg {
    "Perinci::Script::Plugin::$_[0]";
}

sub new {
    my ($class, %args) = (shift, @_);

    my $self = bless \%args, $class;

    # defaults
    $self->{plugins} //= [];

    # load plugins
    for my $plugin (@{ $self->{plugins} }) {
        my $pkg = __plugin_to_pkg($plugin);
        (my $pkg_pm = "$pkg.pm") =~ s!::!/!g;
        require $pkg_pm;
    }

    $self;
}

sub run_plugins {
    my ($self, $hook, $r) = @_;

    $self->{_hook_metas} //= {}; # key = plugin name, val = {$hook_name => $meta, ...}
    $self->{_hook_funcs} //= {}; # key = plugin name, val = {$hook_name => $coderef, ...}

    my @plugins_to_run; # element = [plugin name, priority, order from plugins list, coderef]. lower priority means run first
    my $i = 0;
    for my $plugin (@{ $self->{plugins} }) {
        $i++;
        my $pkg = __plugin_to_pkg($plugin);

        # get metadata
        my $hookmeta_func = "hookmeta_$hook";
        next unless $pkg->can($hookmeta_func);
        say "D: $pkg -> can($hookmeta_func)";
        my $meta = $self->{_hook_metas}{$plugin}{$hook} // do {
            $self->{_hook_metas}{$plugin}{$hook} = $pkg->$hookmeta_func;
        };

        # get hook code
        my $hook_func = "hook_$hook";
        my $coderef = $self->{_hook_funcs}{$plugin}{$hook} // do {
            $self->{_hook_funcs}{$plugin}{$hook} = \&{"$pkg\::$hook_func"};
        };
        push @plugins_to_run, [$plugin, $meta->{priority} // 50, $i, $coderef];
    }

    # order by priority, then by order specified in plugins list
    @plugins_to_run = sort { $a->[1] <=> $b->[1] || $a->[2] <=> $b->[2] }
        @plugins_to_run;

    unless (@plugins_to_run) {
        log_trace "There are no plugins running for hook %s", $hook;
    }

  ENTRY:
    for my $plugin_entry (@plugins_to_run) {
        log_trace "Running hook %s from plugin %s ...", $hook, $plugin_entry->[0];
        my $res = $plugin_entry->[3]->($self, $r);
        if ($res->[0] == 100) { # HTTP: Continue
            # success, continue to next plugin
        } elsif ($res->[0] == 101) { # HTTP: Switching Protocols
            # success, immediately exit hook
            return [200, "Hook succeeded, early exit after $plugin_entry->[0]"];
        } elsif ($res->[0] == 191) { # HTTP: -
            # fail, immediately exit hook
            return [500, "Hook failed, early exi after $plugin_entry->[0]"];
        } elsif ($res->[0] == 192) { # HTTP: -
            # decline, continue to next hook
        } elsif ($res->[0] == 193) { # HTTP: -
            # instruct hook to be repeated
            return [193, "Plugin $plugin_entry->[0] requested hook to be repeated"];
        }
    }
    [200, "Hook succeeded"];
}

sub run {
    my $self = shift;

    my $res;
    my $r = {};

    $self->run_plugins('get_result', $r);
    $self->run_plugins('format_result', $r);
    $self->run_plugins('display_result', $r);
    use DD; dd $self;
}

1;
# ABSTRACT: Run functions described by Rinci in various environments

=head1 SYNOPSIS

 use Perinci::Script;

 Perinci::Script->new(
    function => 'MyApp::app',
 )->run;


For more samples, see L<Perinci::Script::Manual>.


=head1 DESCRIPTION

Perinci::Script is a framework to create scripts that can run your Perl
functions (or functions created in other languages) over various environments,
from CLI to CGI/FCGI/PSGI.


=head1 FUNCTIONS

=head2 run

=head2 run_plugin


=head1 SEE ALSO

L<Rinci>

L<Riap>

L<Perinci::CmdLine> - an older project. Perinci::Script is meant to replace
Perinci::CmdLine by offering more flexibility/customization via plugin
architecture, and multiple environment support (CLI as well as PSGI/CGI).

=cut
