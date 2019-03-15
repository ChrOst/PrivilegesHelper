#!/bin/bash
# get loggedIn User
loggedInUser=$( stat -f %Su /dev/console )
# logFile, must match logfile "checkPrivileges.sh"
logFile="/tmp/privilegesCheck"
# Signalfile, must match de.lrz.privileges.demote.plist -> watchpaths
signalFile="/tmp/checkPrivileges"
# Demote to Standard User if Screensaver is active. You may want this as Argument 4.
demoteIfLocked="yes"

# Demotion function
function demote {
	echo "Demoting the user!"
	sudo -u "${loggedInUser}" /Applications/Privileges.app/Contents/Resources/PrivilegesCLI --remove
	rm "${logFile}"
    rm "${signalFile}"
}

# Ask the User
confirmAdmin=`/usr/bin/osascript <<EOT
tell application "Finder"
	activate
	with timeout of 600 seconds
		set myReply to button returned of (display dialog "Do you still need Administrative Privileges?" buttons {"Yes", "No"} default button 2)
	end timeout
end tell
EOT`
# ErrorCode 1 happens if User is in Lockscreen, you probably want to demote aswell.
# Maybe this also occurs if nobody is logged in, needs some more research
if [[ $? -eq 1 ]] && [[ "${demoteIfLocked}" == "yes" ]]
then
	demote
fi

# If the User said, he doesn't need it, remove it.
if [[ "${confirmAdmin}" == "No" ]]
then
	demote
fi