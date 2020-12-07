need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
use     URI;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::VirtualIOServers::VirtualIOServer::VirtualFibreChannelMappings::VirtualFibreChannelMapping::Port:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                        $names-checked = False;
my      Bool                                        $analyzed = False;
my      Lock                                        $lock = Lock.new;

has     Hypervisor::IBM::POWER::HMC::REST::Config   $.config is required;
has     Bool                                        $.initialized = False;
has     Bool                                        $.loaded = False;

has     Str                                         $.LocationCode;
has     Str                                         $.PortName;
has     Str                                         $.UniqueDeviceID;
has     Str                                         $.WWPN;
has     Str                                         $.WWNN;
has     Str                                         $.AvailablePorts;
has     Str                                         $.TotalPorts;

method  xml-name-exceptions () { return set <Metadata>; }

submethod TWEAK {
    self.config.diag.post:      self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_SUBMETHOD>;
    my $proceed-with-name-check = False;
    my $proceed-with-analyze    = False;
    $lock.protect({
        if !$analyzed           { $proceed-with-analyze    = True; $analyzed      = True; }
        if !$names-checked      { $proceed-with-name-check = True; $names-checked = True; }
    });
    self.etl-node-name-check    if $proceed-with-name-check;
    self.init;
    self.analyze                if $proceed-with-analyze;
    self;
}

method init () {
    return self             if $!initialized;
    self.config.diag.post:  self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_METHOD>;
    self.load               if self.config.optimization-init-load;
    $!initialized           = True;
    self;
}

method load () {
    return self             if $!loaded;
    self.config.diag.post:  self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_METHOD>;
    $!LocationCode          = self.etl-text(:TAG<LocationCode>,     :$!xml, :optional);
    $!PortName              = self.etl-text(:TAG<PortName>,         :$!xml, :optional);
    $!UniqueDeviceID        = self.etl-text(:TAG<UniqueDeviceID>,   :$!xml, :optional);
    $!WWPN                  = self.etl-text(:TAG<WWPN>,             :$!xml, :optional);
    $!WWNN                  = self.etl-text(:TAG<WWNN>,             :$!xml, :optional);
    $!AvailablePorts        = self.etl-text(:TAG<AvailablePorts>,   :$!xml, :optional);
    $!TotalPorts            = self.etl-text(:TAG<TotalPorts>,       :$!xml, :optional);
    $!xml                   = Nil;
    $!loaded                = True;
    self;
}

=finish
