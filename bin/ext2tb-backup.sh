#!/bin/sh

# rsync backup utility script
#

#config
OPT="-arPh"
SRC="/mnt/public/music/"
DEST="/mnt/windata/Music/"
NAME="BANDIT"
SPACE="."
DATE=`date "+%F_%s"`

# rsync to backup
rsync $OPT --exclude-from='/home/doug/bin/rexcludes.txt' $SRC ${DEST}$NAME$SPACE$DATE

exit 0;
