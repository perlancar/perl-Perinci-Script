package Perinci::Script::Plugin::FormatResult::JSON;

# DATE
# VERSION

sub hookmeta_format_result {
    +{
        priority => 50,
    };
}

sub hook_format_result {
    my ($self, $r) = @_;

    require JSON;
    $r->{formatted_result} = JSON::encode_json($r->{result});
    [100];
}

1;
# ABSTRACT:
