package Perinci::Script::Plugin::FormatResult::Stdout;

# DATE
# VERSION

sub hookmeta_display_result {
    +{
        priority => 50,
    };
}

sub hook_display_result {
    my ($self, $r) = @_;

    print $r->{formatted_result};
    [100];
}

1;
# ABSTRACT:
