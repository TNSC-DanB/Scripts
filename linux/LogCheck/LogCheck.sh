#!/bin/bash

FILE=test.txt
STATUSFILE=LogCheck.status
MAILTO=recipient@contoso.com
MAILFROM=sender@contoso.com

FILEHASH=$(cat $FILE.md5)
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
	echo "Log file $FILE on $HOSTNAME has not been updated since $MODTIME.  It would appear that the process is not functioning properly.  Please investigate!" | mail -s "Stale $FILE on $HOSTNAME" -a "From: $MAILFROM" $MAILTO
   else
	echo "Previous status was alert, e-mail already sent."
   fi
   
   echo "ALERT" > $STATUSFILE
else
   echo "Log updated, all clear"
   echo "clear" > $STATUSFILE
fi

md5sum $FILE > $FILE.md5
