package Perinci::Script;

# DATE
# VERSION

1;
# ABSTRACT: Run functions described by Rinci in various environment

=head1 DESCRIPTION

Perinci::Script is a framework to create scripts that can run your Perl
functions (or functions created in other languages) over various environments,
from CLI to CGI/FCGI/PSGI.

 Perinci::Script::Base
   Perinci::Script::CLI::Base          (old name: Perinci::CmdLine::Base)
     Perinci::Script::CLI::Lite        (old name: Perinci::CmdLine::Lite)
     Perinci::Script::CLI::Heavy       (old name: Perinci::CmdLine::Classic)
     Perinci::Script::CLI::HTMLForm    for scripts invoked from the command-line but opens browser and presents the UI as HTML form. runs HTTP server locally.
   Perinci::Script::CLI::Any           (old name: Perinci::CmdLine::Any)
   Perinci::Script::CLI::CUI

   Perinci::Script::CGI
   Perinci::Script::CGI::API           for scripts to be run as CGI script, return JSON response
   Perinci::Script::CGI::HTML          for scripts to be run as CGI script, presents HTML form and return HTML/JSON

   Perinci::Script::FCGI
   Perinci::Script::FCGI::API          for scripts to be run as FCGI script, return JSON response
   Perinci::Script::FCGI::HTML         for scripts to be run as FCGI script, presents HTML form and return HTML/JSON

   Perinci::Script::PSGI
   Perinci::Script::PSGI::API          for scripts to be run as PSGI script, return JSON response
   Perinci::Script::PSGI::HTML         for scripts to be run as PSGI script, presents HTML form and return HTML/JSON

   Perinci::Script::CUI?
   Perinci::Script::GUI?

 Perinci::Script::HTTP::Any?           for scripts to be run as CGI/FCGI/PSGI depending on the environment

 Perinci::Script::Any                  for scripts to to be run as CLI, CGI, FCGI, or PSGI depending on the environment


=head1 SEE ALSO

L<Rinci>

L<Riap>

=cut
