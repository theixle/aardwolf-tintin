### TinTin++ Settings for Aardwolf MUD

## Setup:
* Clone the repository
* Edit username in config.tin
* Edit password in config.tin
* Edit bag in config.tin
* Edit paths in aardwolf-session

## Usage:
* Launch tmux (tmux -2)
* Run aardwolf-session (./aardwolf-session)
* In-game: tags channel on
* In-game: tags map on
* In-game: tags mapexits on 
* In-game: tags mapnames on
* In-game: tags roomchars on
* In-game: tags roomobjs on

## Features
* GMCP powered 2-line prompt with colored percentage meters (prompt.tin)
* Quest time ticker and target tracking (quest.tin)
* Repop watch and announce (gmcp.tin)
* Minimap in seperate window (minimap.tin)
* Alias-driven note jotting system (aliases.tin)
* Channels logged to separate window (gmcp.tin)
* Room characters/mobiles and objects logged to file (minimap.tin)

## Commands
* debug on|off  - toggles echoing GMCP data as it arrives
* repopwatch on|off - toggles announcing of repops in $repchan
* .note *message here* - adds *message* to notes.log (bottom right window)
* .newpage - clears the note screen, providing a fresh page


The actions.tin and aliases.tin files are a place for your personal triggers and aliases. 
