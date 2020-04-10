#!/bin/sh

# rsync backup utility script
#

#config
OPT="-arPh"
SRC="/mnt/public/music/"
DEST="/home/doug/Willow/backups/Music/"
NAME="BANDIT-01"
SPACE="."
DATE=`date "+%F_%s"`

# rsync to backup
rsync $OPT --exclude-from='/home/doug/.rexcludes.txt' $SRC ${DEST}$NAME$SPACE$DATE

exit 0;
