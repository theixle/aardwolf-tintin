This script was created by the player 'Tharnin' and all credit (and questions about issues) should go to him.

Usage: convertmap.pl /MUSHCient/path/Aardwolf.db /ouput/path/tintinmap.tt

This script requires perl, the DBI module, and the SQLite DBD backend for the
DBI module.

This script will read the database created by the MUSHClient mapper plugin of
the Aardwolf MUSHClient package, and output a file you can read into tintin
with "#MAP READ", effectively converting your mushclient's map to a tintin
map to ease your transition and prevent having to reexplore the world to
build your map from scratch.

Both paths may be given as relative, and the path given as an output file
name will be (over)written.

Custom exits are preserved, portable portals are not. You'll have to add them
manually to paths.tin if you haven't already.


