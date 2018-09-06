#!/usr/bin/perl

use strict;
use warnings;

use DBI;

unless ($ARGV[0] && $ARGV[1]) {
    print "Syntax: $0 mushmap_db_name ttmap_file_name\n";
    exit 1;
};

my %dirs = (
    n => 1,
    e => 2,
    s => 4,
    w => 8,
    u => 16,
    d => 32,
    ne => 3,
    nw => 6,
    se => 9,
    sw => 12,
);

print "Converting $ARGV[0] to $ARGV[1].\n";

open FH, "> $ARGV[1]" or die "Unable to open $ARGV[1] for writing: $!\n";

# The header is more or less constant. If you want to change things, do it
# from inside tintin. These can be considered magic numbers for the sake of
# this script, they were pulled from a fresh map (#MAP CREATE, #MAP WRITE).
print FH "C 60000\n\n";     # Map size.
print FH "CE <078>\n";      # Exit color.
print FH "CH <118>\n";      # Here color.
print FH "CP <138>\n";      # Path color.
print FH "CR <178>\n\n";    # Room color.
print FH "F 8\n\n";         # Map flags.
print FH "I 0\n\n";         # Current room.
print FH "L * # #  # |   #        x\n\n";    # Map Legend.

# Now we have the header written, go through rooms and convert them.
my $dbh = DBI->connect("DBI:SQLite:dbname=$ARGV[0]","","") or die
    "Couldn't connect to $ARGV[0] database: ".DBI->errstr()."\n";

my $sth_rooms = $dbh->prepare('SELECT rooms.uid, rooms.name, rooms.area, rooms.notes, rooms.terrain, rooms.info FROM rooms')
    or die "Couldn't prepare room selection query: ".$dbh->errstr()."\n";
my $sth_exits = $dbh->prepare("SELECT exits.touid, exits.dir FROM exits WHERE fromuid = ?")
    or die "Couldn't prepare exits selection query: ".$dbh->errstr."\n";

# Build the known rooms list. Can't write the map as we go because tintin
# considers it an error to have errors that refer to rooms that don't
# exist. The idea, then, is to read all the rooms--including their
# exits--and record them, adding unknown rooms to the list to make the
# exit constraint happy, then write the list in a second pass.
my $known_rooms = {};
my $roominfo = $sth_rooms->fetchrow_hashref();
my $exitinfo;

$sth_rooms->execute() or die "Failed to execute room selection query: ".$sth_rooms->errstr."\n";
$roominfo = $sth_rooms->fetchrow_hashref();
while (defined $roominfo) {
    if (not defined $roominfo->{notes}) {$roominfo->{notes} = '';}
    if (not defined $roominfo->{info})  {$roominfo->{info} = '';}

    $roominfo->{color} = '<178>';   # Known rooms are given this color by default.

    $exitinfo = $sth_exits->execute(($roominfo->{uid})) or die "Failed to execute exit selection query: ".$sth_rooms->errstr."\n";
    $exitinfo = $sth_exits->fetchrow_hashref();
    while (defined $exitinfo) {
        if (defined $dirs{$exitinfo->{dir}}) { $exitinfo->{dnum} = $dirs{$exitinfo->{dir}}; }
        else                                 { $exitinfo->{dnum} = 0; }

        # If the room isn't known, add a dummy room, it'll get overwritten by
        # the known data later if we come across it.
        if (not defined $known_rooms->{$exitinfo->{touid}}) {
            $known_rooms->{$exitinfo->{touid}} = {
                uid => $exitinfo->{touid},
                name => '',
                area => '',
                notes => '',
                terrain => '',
                info => '',
                color => '<fca>',   # Default color for unknown rooms.
            };
        }

        $roominfo->{exits}{$exitinfo->{dir}} = $exitinfo;
        $exitinfo = $sth_exits->fetchrow_hashref();
    };
    $known_rooms->{$roominfo->{uid}} = $roominfo;
    $roominfo = $sth_rooms->fetchrow_hashref();
};

my $roomline;
my $exitline;
my $roomcount = 0;
my $exitcount = 0;

foreach my $roominfo (sort {$a->{uid} <=> $b->{uid}} values %{$known_rooms}) {
    $roomline = sprintf("\nR {%5d} {%d} {%s} {%s} {%s} {%s} {%s} {%s} {%s} {%s} {%.3f}\n",
                    $roominfo->{uid},       # Vnum
                    0,                      # Flags
                    $roominfo->{color},     # Color
                    $roominfo->{name},      # Name
                    ' ',                    # Symbol
                    '',                     # Description
                    $roominfo->{area},      # Area
                    $roominfo->{notes},     # Notes
                    $roominfo->{terrain},   # Terrain
                    $roominfo->{info},      # Data
                    '1.000');               # Weight
    print FH $roomline;

    foreach $exitinfo (values %{$roominfo->{exits}}) {
        $exitline = sprintf("E {%5d} {%s} {%s} {%d} {%d} {%s}\n",
            $exitinfo->{touid},     # Destination
            $exitinfo->{dir},       # Name
            $exitinfo->{dir},       # Command
            $exitinfo->{dnum},      # Direction
            0,                      # Flags
            '');                    # Data.
        print FH $exitline;
        $exitcount = $exitcount + 1;
    };
    $roomcount = $roomcount + 1;
};

print "Converted $roomcount rooms wth $exitcount exits.\n";

$sth_rooms->finish();
$sth_exits->finish();

$dbh->disconnect();

close FH;
