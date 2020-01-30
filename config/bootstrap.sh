#!/bin/bash
# Run ssh on logging, only if not running yet
ACTIVE=$(pgrep -f /usr/sbin/sshd)
chmod 777 /usr/sbin/sshd
ls -l /usr/sbin/
echo "PSID -> $ACTIVE"
if [ ! "$ACTIVE" ]; then
	echo "starting sshd....";
	/usr/sbin/sshd
	echo "successfully started PID = $(pgrep -f /usr/sbin/sshd)";
else
    echo "ssh service already started PID=$ACTIVE"
fi
#to stop container from exit
tail -f /dev/null