#!/bin/sh

### If you want more an App that'll stay open with a droplet
### download https://sveinbjorn.org/platypus
### set the shell script to this script
### Click args, add arguments for the script
### set interface to droplet
### click accepts dropped items
### click settings, and click Accept dropped files


### if you want to make an automater app
### comment output line and sips line and uncomment echo iconpath line
### Create an automater application
### 3 pieces in it
### 1) Run Shell Script, set it to pass input as arguments
### 2) Copy Finder Items
### 3) Change type of Image

### Or just run as is from the command line and pass the application as an argument

AppPath=$1
InfoPlist="${AppPath}/Contents/Info.plist"
AppName=$(defaults read "${InfoPlist}" CFBundleDisplayName)
IconName=$(defaults read "${InfoPlist}" | grep CFBundleIconFile | awk '{print $3}' | tr -d '"' | tr -d ";")

if [ "${IconName: -5}" != ".icns" ]; then
	IconName="${IconName}.icns"
fi

IconPath="${AppPath}/Contents/Resources/${IconName}"

#echo "${IconPath}"

output="${AppName}.png"
sips -s format png "${IconPath}" --out ~/Desktop/"${output}"
