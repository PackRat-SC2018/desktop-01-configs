#!/bin/sh

# rsync backup utility script
#

#config
OPT="-arPh"
SRC="/home/doug/"
# DEST="/run/media/doug/USB-14GB/backups/"
DEST="/run/media/doug/SDHC-32GBL/backups/"
NAME="BANDIT-01"
SPACE="."
DATE=`date "+%F_%s"`

# rsync to backup
rsync $OPT --exclude-from='/home/doug/.rexcludes.txt' $SRC ${DEST}$NAME$SPACE$DATE

exit 0;
