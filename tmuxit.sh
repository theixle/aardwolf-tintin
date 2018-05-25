#!/usr/bin/env bash

# This bash script will start up tmux in a multi-paned environment.
#
# It takes a single parameter, the directory for your settings file. If none
# is provided, it assumes the directory in which it was run.
#
# Requires Tmux 1.5

# Screen Size
SIZE[X]="$(tput cols)"
SIZE[Y]="$(tput lines)"
# Session Name
SESSION="aardwolf"
# Screen Splitting Ratios
# TODO: More Detail
SPL1=0.82
SPL2=0.79
SPL3=0.28
# tintin++ executable. I don't know why you'd want to change this.
EXE="tt++"
# Files
CHAT="Aardwolf-chats"
CHARS="chars"

# Validated Dir Name
if [ "$1" = "" ]
then
  DIR="."
else
  if [ -d "$1" ]
  then
    DIR="$1"
  else
    echo "Given directory does not exist!"
    exit -1
  fi
fi
DIR="$(readlink -f $DIR)"

# Helper Functions
fmultiply(){
  bc -l <<< "$1*$2"
}

trunc(){
  echo ${1%.*}
}

tmux kill-session -t $SESSION
tmux new-session -d -s aardwolf -x $X -y $Y
#tmux splitw -h -l 159 "tail -fs .1 $DIR/Aardwolf-chats"
#tmux splitw -v -l 37 "tt++ -G $DIR/setup.tin;bash -i"
#tmux splitw -h -l 68 "tail -fs .1 $DIR/chars"
#tmux selectp -t 0
#tmux splitw -v -l 22 "tail -fs .1 $DIR/minimap"
#tmux selectp -t 0
#tmux splitw -v -l 14 "tail -fs .1 $DIR/group"
#tmux selectp -t 5
#tmux splitw -v -l 20 "tail -fs .1 $DIR/quest"
#tmux selectp -t 4
#tmux attach-session -t aardwolf


#TODO: Validate Screen Size
# Test the minimum useable screen size and hard code it

#tmux kill-session -t $SES_NAME
#tmux new-session -d -s $SES_NAME -x $X -y $Y
#tmux split-window -h -l $(trunc $(fmultiply $X $SPL1)) "tail -fs .1 $DIR/$CHAT"
#tmux split-window -v -l $(trunc $(fmultiply $Y $SPL2)) "$EXE"
#tmux split-window -h -l $(trunc $(fmultiply $X $SPL3)) "tail -fs .1 $DIR/$CHARS"
echo $X $(tput cols)
echo $Y $(tput lines)
#tmux attach-session -t $SES_NAME
