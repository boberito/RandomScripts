#!/usr/bin/osascript

display dialog "Please enter the computer name. You will be asked for your admin credentials to authorize the change. Then you will be taken to the Jamf Enrollment" buttons {"Ok"} default button {"Ok"}
set myComputer to the text returned of (display dialog "Enter computer name" default answer "" )
do shell script "
scutil --set ComputerName " & myComputer & "
scutil --set LocalHostName " &  myComputer &"
scutil --set HostName " &  myComputer with administrator privileges

tell application "Safari" to open location "URL-TO-JAMF-ENROLLMENT-PAGE" activate
