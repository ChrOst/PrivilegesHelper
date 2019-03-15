#!/bin/bash
# Based on: Travelling Tech Guy - 6th of March 2019 - Proof of concept - use at own risk! - https://github.com/TravellingTechGuy/privileges/blob/master/checkAdmin.sh
# Modified by: Christoph Ostermeier (Leibniz-Rechenzentrum) - 2019-03-15

# Timelimit in Seconds
timeLimit="1800"
# Signalfile, must match de.lrz.privileges.demote.plist -> watchpaths
signalFile="/tmp/privilegesDemote"
# logFile which contains the timestamps of the last runs
logFile="/tmp/privilegesCheck"
# current timestamp
timeStamp=$(date +%s)

# check if file exists
if [ -f ${logFile} ]
then
	echo "File ${logFile} exists."
else
	echo "File ${logFile} does NOT exists"
	touch "${logFile}"
	echo ${timeStamp} > ${logFile}
fi	

# grab the logged in user
loggedInUser=$( stat -f %Su /dev/console )
# check if the user is admin
if [[ $("/usr/sbin/dseditgroup" -o checkmember -m ${loggedInUser} admin / 2>&1) =~ "yes" ]]
then
	echo "User is Admin... keeping an eye on him/her!"
	userType="Admin"
else
	echo "User is not admin... bye bye"
	userType="Standard"
	rm "${logFile}"
	exit
fi
		
# process Admin time
if [[ "${userType}" == "Admin" ]]
then	
	oldTimeStamp=$(head -1 ${logFile})
	echo ${timeStamp} >> ${logFile}

	adminTime=$((${timeStamp} - ${oldTimeStamp}))
	echo "Admin time in seconds: ${adminTime}"
fi

echo "Time Limit is ${timeLimit} seconds"
	
# if user is admin for more than the time limit, ask (via jamf) if to confirm need for superpowers

if [[ ${adminTime} -ge ${timeLimit} ]]
then
	touch "${signalFile}"
	sleep 5
	rm "${signalFile}"
fi
