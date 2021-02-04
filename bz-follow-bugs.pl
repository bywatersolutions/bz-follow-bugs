#!/usr/bin/env perl

use Modern::Perl;

use BZ::Client::REST;
use Getopt::Long::Descriptive;
use List::Util qw(any);

my ( $opt, $usage ) = describe_options(
    $0,
    [ 'bz-url=s',      'Community tracker URL',      { required => 1, default => $ENV{BZ_URL} } ],
    [ 'bz-username=s', 'Community tracker username', { required => 1, default => $ENV{BZ_USER} } ],
    [ 'bz-password=s', 'Community tracker password', { required => 1, default => $ENV{BZ_PW} } ],
    [],
    [ 'assignee|a=s@',    'Bug assignee to search for', { default => [split(',', $ENV{BZ_ASSIGNEE} // q{})] } ],
    [ 'email|e=s',        'Email address to cc for the bug', { default => $ENV{BZ_USER} } ],
    [],
    [ 'verbose|v+', 'Print extra stuff', { required => 1, default => 0 } ],
    [ 'help|h', 'Print usage message and exit', { shortcircuit => 1 } ],
);

my $assignees = $opt->assignee;

print( $usage->text ), exit if $opt->help || !@$assignees;

my $v = $opt->verbose;

my $bz_url  = $opt->bz_url;
my $bz_user = $opt->bz_username;
my $bz_pass = $opt->bz_password;

my $email = $opt->email;

my $client = BZ::Client::REST->new(
    {
        user     => $bz_user,
        password => $bz_pass,
        url      => $bz_url,
    }
);

my $statuses = [
    "NEW",
    "REOPENED",
    "ASSIGNED",
    "In Discussion",
    "Needs Signoff",
    "Passed QA",
    "Failed QA",
    "Patch doesn't apply",
];

my $bugs = $client->search_bugs(
    {
        assigned_to => $assignees,
        status => $statuses,
    }
);

foreach my $b ( @$bugs ) {
    my $cc = $b->{cc};
    say "WORKING ON $b->{id}" if $v;
    next if any { $_ eq $email } @$cc;
    say "CC NOT FOUND" if $v;
    my $r = $client->update_bug( $b->{id}, { cc => { add => [$email] } } );
    say "Added CC for Bug $b->{id}" if $r && $v > 1;
    say "FAILED to add CC for Bug $b->{id}" unless $r;
}

say "Finished!" if $v;
