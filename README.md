# Privileges Helper Scripts

- create a Package containing checkPrivileges.sh (-> /usr/local/bin/) and the LaunchDaemon Files (-> /Library/LaunchDaemon/)
- add postinstall Script which registers them
```
launchctl load -w /Library/LaunchDaemons/de.lrz.privileges.demote.plist
launchctl load -w /Library/LaunchDaemons/de.lrz.privileges.check.plist
```
- create demotePrivileges.sh inside jamfPro
- create Policy inside jamfPro with custom trigger "privilegesDemote", set it to ongoing and make it available offline!
- create a TCC Payload with PPPCUtility allowing /usr/local/bin/jamf to send Events to Finder
- Install Package beside Privileges.pkg on the clients



# Why so complicated?
- calling the script each time from jamfPro would spam the logs and ofc the server
- demoting locally without use of jamfPro would require you to sign the script AND there are no auditable logs
- a TCC payload is always required to display a Finder prompt (which is what you want, as users won't be able to ignore this one!)


# Credits
Big thanks for [TravellingTechGuy](https://github.com/TravellingTechGuy) for the idea.

