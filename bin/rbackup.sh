#!/bin/sh

# rsync backup utility script
#

#config
OPT="-arPh"
SRC="/home/doug/"
DEST="/mnt/Willow/bandit/"
DATE=`date "+%F_%s"`

# rsync to backup
rsync $OPT --exclude-from='/home/doug/.rexcludes.txt' $SRC ${DEST}$DATE

