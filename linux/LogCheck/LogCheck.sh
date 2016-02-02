#!/bin/bash

FILE=test.txt
MAILTO=recipient@contoso.com
MAILFROM=sender@contoso.com

WORKINGDIR="$(dirname $0)"
cd $WORKINGDIR

LOGFILE="$0.log"
STATUSFILE="$(basename $FILE).alarm"
HASHFILE="$(basename $FILE).md5"
FILEHASH=$(cat $HASHFILE)
STATUS=$(cat $STATUSFILE)
NEWHASH=$(md5sum $FILE)
MODTIME=$(stat -c %y $FILE | sed 's/$FILE//')


if [ -e $STATUSFILE ];then
	echo "StatusFile Exists"
else
	touch $STATUSFILE && echo "Created status file" 
fi

echo "Filehash is $FILEHASH NewHash is $NEWHASH"

if [[ "$FILEHASH" == "$NEWHASH" ]]; then
   echo "File not updated!"

   if [[ "$STATUS" != "ALERT" ]]; then
	echo "Previous status was not an alert! Send e-mail!"
	echo "Monitored log file $FILE on $HOSTNAME has not been updated since $MODTIME.  It would appear that the process that writes to this log is not functioning properly.  Please investigate!  This alert was generated by the script located at $(pwd)$0." | mail -s "ALERT: Stale log $(basename $FILE) on $HOSTNAME" -a "From: $MAILFROM" $MAILTO
   else
	echo "Previous status was alert, e-mail already sent."
   fi
   
   echo "ALERT" > $STATUSFILE
else
   echo "Log updated, all clear"
   echo "clear" > $STATUSFILE
fi

md5sum $FILE > $HASHFILE

NEWSTATUS=$(cat $STATUSFILE)

echo "$(date),$0,$(pwd),$(whoami),$FILEHASH,$NEWHASH,$STATUS,$NEWSTATUS" >> $LOGFILE
