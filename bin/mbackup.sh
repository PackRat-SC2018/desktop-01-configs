#!/bin/sh

# rsync backup utility script
#

#config
OPT="-arPh"
SRC="/mnt/public/music/"
DEST="/mnt/data02/Music/"
NAME="BANDIT-01"
SPACE="."
DATE=`date "+%F"`

# rsync to backup
rsync $OPT --exclude-from='/home/doug/.rexcludes.txt' $SRC ${DEST}$NAME$SPACE$DATE
