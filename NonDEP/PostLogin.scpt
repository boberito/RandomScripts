#!/usr/bin/osascript

set theName to the text returned of (display dialog "What is the Computer name?" default answer "")

display dialog "Enter the credentials to allow the computer name to be changed. You will then be taken to the Jamf Enrollment." buttons {"Ok"} default button "Ok"

do shell script "
scutil --set ComputerName " & theName & "
scutil --set LocalHostName " & theName & "
scutil --set HostName " & theName & "

launchctl unload /Library/LaunchAgents/com.YOURNAME.setup.plist
rm -f /Library/LaunchAgents/com.YOURNAME.setup.plist 
rm -f /private/var/PostLogin.scpt
" with administrator privileges

tell application "Safari" to (open location "https://JamfProEnrollmentPage") activate
