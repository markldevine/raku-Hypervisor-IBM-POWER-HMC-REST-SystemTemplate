need    Hypervisor::IBM::POWER::HMC::REST::Config::Options;
need    MessageStream::Message;
need    MessageStream;
use     Terminal::ANSIColor;
unit    class Hypervisor::IBM::POWER::HMC::REST::Messaging::NOTE:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does MessageStream;

my      \NOTE-COLORS    = 'red';
my      \ADDED-PAD      = 4;

has     Hypervisor::IBM::POWER::HMC::REST::Config::Options    $.options   is required;

method NOTE-TTY-receive (MessageStream::Message:D $message) {
    $*ERR.put: colored($message.payload.Str, NOTE-COLORS) if $message.payload;
}

=finish
