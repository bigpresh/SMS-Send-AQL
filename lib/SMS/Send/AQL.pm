package SMS::Send::AQL;

# $Id: AQL.pm 281 2008-03-09 01:54:50Z davidp $

use strict;
use warnings;
use SMS::AQL;
our $VERSION = '0.03';
use base 'SMS::Send::Driver';




=head1 NAME

SMS::Send::AQL - SMS::Send driver to send messages via AQL (www.aql.com)

=head1 SYNOPSIS

  use SMS::Send;
  
  # Create a sender
  my $sender = SMS::Send->new('AQL',
        _username => 'your_aql_username',
        _password => 'your_aql_password',
        _sender   => 'sender number',
        );
  
  # Send a message
  my $sent = $sender->send_sms(
        text => 'This is a test message',
        to   => '+61 (4) 1234 5678',
        );
  
  if ( $sent ) {
        print "Message sent ok\n";
  } else {
        print "Failed to send message\n";
  }


=head1 DESCRIPTION

A driver for SMS::Send to send SMS text messages via AQL (www.aql.com)

This is not intended to be used directly, but instead called by SMS::Send
(see synopsis above for a basic illustration, and see SMS::Send's documentation
for further information).



=head1 METHODS

=over 4

=item new

Constructor, takes argument pairs passed by SMS::Send, returns an SMS::Send::AQL
object.  See usage synopsis for example, and see SMS::Send documentation for
further info on using SMS::Send drivers.

=cut

sub new {

    my ($class, %args) = @_;

    my $self = bless { %args }, $class;
    
    # we accept _login for compatibility with the example shown in SMS::Send
    # documentation (principle of least surprise, if people expect that to
    # work, we may as well make it work :) )
    if (exists $args{_login} && ! exists $args{_username}) {
        $args{_username} = $args{_login};
    }
    
    if (grep { ! $args{$_} } qw(_username _password)) {
        die "_username (or _login) and _password required";
    }
    
    
    
    $self->{aql} = new SMS::AQL({
        username => $args{_username},
        password => $args{_password},
        options => {
            sender => $args{_sender} || 'SMS::AQL',
        },
    });
    
    return $self;

}



=item send_sms

Send the message - see SMS::Send for details.

=cut

sub send_sms {

    my ($self, %args) = @_;
    
    # AQL's gateway won't accept numbers in the format +441234567890,
    # it wants to see 00441234567890 instead:
    $args{to} =~ s/^\+/00/;
    
    
    return $self->{aql}->send_sms(@args{ qw (to text) });

}



=back

=head1 AUTHOR

David Precious, E<lt>davidp@preshweb.co.ukE<gt>


=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by David Precious

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut



1;
__END__
