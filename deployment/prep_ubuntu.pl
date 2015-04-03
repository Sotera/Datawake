#!/usr/bin/perl

print "\nHello! This PERL script will install everything needed to run Datawake";
print "\non an Ubuntu 14.04 machine instance. It does no checking of OS type or";
print "\nversion (that's up to you) and requires that the account running it be";
print "\nin the 'sudo-ers' list.\n\n";

prompt_yn('Continue?') || die;

#Get use to enter 'sudo' password
`sudo ls`;

#Turn on SSH (This should only apply to Bitnami stacks)

#Use scalar and interpolating back-tick operator to avoid forward slash/regex issues
print "Creating new SSH keys ...\n"; 
$key_filename = '/etc/ssh/ssh_host_rsa_key';
print `sudo echo -e 'y\n'|sudo ssh-keygen -q -t rsa -N "" -f $key_filename`;

$key_filename = '/etc/ssh/ssh_host_dsa_key';
print `sudo echo -e 'y\n'|sudo ssh-keygen -q -t dsa -N "" -f $key_filename`;

print `sudo cp /etc/init/ssh.conf.back /etc/init/ssh.conf`;
print "Restarting SSH daemon ...\n";
print `sudo start ssh`;


#Shutdown MEAN stack and set to no auto-restart (This should only apply to Bitnami stacks)
if(-e '/opt/bitnami/ctlscript.sh'){
    #if(prompt_yn('shutdown MEAN stack?'))
    #{
    print "Shutting down MEAN stack and disabling MEAN stack on startup";
    print `sudo /opt/bitnami/ctlscript.sh stop`;
    print `sudo update-rc.d bitnami disable`;
    #}
}

print "Updating aptitude caches ...\n";
print `sudo apt-get update`;

print "Getting aptitude HTTPS support ...\n";
print `sudo apt-get -y install apt-transport-https`;

print "Getting the latest Docker packages ...\n";
print `curl -ssl https://get.docker.com/ubuntu/ |sudo sh`;
print `source /etc/bash_completion.d/docker`;

print "Updating aptitude ...\n";
print `sudo apt-get update`;

print "Installing apparmor ...\n";
print `sudo apt-get -y install apparmor apparmor-utils`;

print "Installing PIP ...\n";
print `sudo apt-get -y install python-pip`;

print "Installing FIG ...\n";
print `sudo pip install fig`;

print "Creating 'src' directory & Cloning Datawake.git ...\n";
#print `mkdir src; cd src; git clone -b DatawakeDemo042015 https://github.com/Sotera/Datawake.git`;

print "Writing fig.yml to Datawake/dev-env ...\n";
@lines = <DATA>;
open(FILE, '> src/Datawake/dev-env/fig.yml');
foreach(@lines){
    print FILE "$_";
}
close(FILE);

print "Starting Docker ...\n";
print `sudo service docker start`;

print "Getting and turning up 'all-in-one' docker container ...\n";
print `cd src/Datawake/dev-env; sudo fig up -d datawakeone;`;

print "Setting up MySQL database and creating test user ...\n";
print `cd src/Datawake/dev-env; sudo ./init_db.sh;`;

print "Turning up remaining docker containers ...\n";
print `cd src/Datawake/dev-env; sudo fig up -d;`;

sub prompt {
    my ($query) = @_; # take a prompt string as argument
    local $| = 1; # activate autoflush to immediately show the prompt
    print $query;
    chomp(my $answer = <STDIN>);
    return $answer;
}
sub prompt_yn {
    my ($query) = @_;
    my $answer = prompt("$query (Y/N): ");
    return lc($answer) eq 'y';
}
__END__
datawakeone:
  build: ../server
  ports:
    - "80:80"
  environment:
    MYSQL_ROOT_PASSWORD: root
    DW_DB: memex_sotera
    DW_DB_USER: root
    DW_DB_PASSWORD: root
    DW_DB_HOST: localhost
    DW_DB_PORT: 3336
    DW_MOCK_AUTH:  1
    DW_MOCK_FORENSIC_AUTH: 1
    DW_CONN_TYPE: mysql
  volumes:
    - ~/src/Datawake/server/datawake:/usr/local/share/tangelo/web/datawake
    - ~/src/Datawake/server/forensic:/usr/local/share/tangelo/web/forensic

