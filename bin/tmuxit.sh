#!/usr/bin/env bash

# This bash script will start up tmux in a multi-paned environment.
#
# It takes a single parameter, the directory for your settings file. If none
# is provided, it assumes the directory in which it was run.
#
# Requires Tmux 1.5

# Screen Size
#TODO: Validate Screen Size
# Test the minimum useable screen size and hard code it
X="$(tput cols)"
Y="$(tput lines)"
# Session Name
SESSION="aardwolf"
# Screen Splitting percentages
# TODO: More Detail?
SPL1=82
SPL2=79
SPL3=28
SPL4=34
SPL5=50
SPL6=30
# tintin++ executable. I don't know why you'd want to change this.
EXE="tt++"
# Files
CHAT="Aardwolf-chats"
CHARS="chars"
MAP="minimap"
GRP="group"
QST="quest"
SETUP="setup.tin"
LOGDIR="log"
MAPDIR="map"
CONFDIR="conf"

# Validated Dir Name
if [ "$1" = "" ]
then
  DIR="."
else
  if [ -d "$1" ]
	then
    DIR="$1"
  else
    printf "Given directory does not exist!\n"
    exit -1
  fi
fi
DIR="$(readlink -f $DIR)"

# Check for existing session
printf "Looking for existing session : "
$(tmux has -t $SESSION)
if [ $? == 0 ]
then
  printf "Session already exists. Attaching to previous session.\n"
	tmux a -d -t $SESSION
	exit
fi

# Setup tiled window view
tmux new -d -s $SESSION -x $X -y $Y
tmux splitw -h -p $SPL1 "tail -fs .1 $DIR/$LOGDIR/$CHAT"
tmux splitw -v -p $SPL2 "$EXE -G $DIR/$SETUP; bash -i"
tmux splitw -h -p $SPL3 "tail -fs .1 $DIR/$LOGDIR/$CHARS"
tmux selectp -t 0
tmux splitw -v -p $SPL4 "tail -fs .1 $DIR/$MAPDIR/$MAP"
tmux selectp -t 0
tmux send-keys 'printf "tmux kill-session $SESSION - to exit"' Enter
tmux send-keys 'printf "ctrl-b d" to detatch' Enter
tmux splitw -v -p $SPL5 "tail -fs .1 $DIR/$LOGDIR/$GRP"
tmux selectp -t 5
tmux splitw -v -p $SPL6 "tail -fs .1 $DIR/$LOGDIR/$QST"
tmux selectp -t 4
tmux attach-session -t $SESSION
