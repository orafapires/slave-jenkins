#!/bin/bash

export PATH=`echo $PATH`

JENKINS_URL=""
JENKINS_CLI=""
USERNAME=""
PASSWORD=""
SLAVEFILE=""

# Create session in Jenkins
java -jar $JENKINS_CLI -s $JENKINS_URL login --username $ACCESS --password $ACCESS

# Checking Jenkins offline and restart if offline
for JENKINS_NODENAME in `cat $SLAVEFILE`
do
	CHECKED=`curl --silent $JENKINS_URL/computer/$JENKINS_NODENAME/api/json | grep -Po '"offline":true' | cut -d':' -f2`
	if [[ "$CHECKED" == "true" ]]; then
        	ssh -tt $JENKINS_NODENAME './kill-slave.sh'
        	exit 0
				else
					echo "INFO: $JENKINS_NODENAME is online, no need to restart."
	fi
done
