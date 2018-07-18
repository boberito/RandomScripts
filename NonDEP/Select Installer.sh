#!/bin/sh

###Location of Package to be installed post HS Install
###If ran as a policy set the location of the package in the first argument, field $4
###You can pass the location as an argument, hard code the location below, or pick it through a dialog.
##if passed as an argument it must be quoted ex: "/My Path/To My/Package.pkg"
###If jamf helper is found then do things the jamf way because most likely this was ran through Self Service and as a Jamf policy

if [ "$4" != "" ]; then
    packageLocation="$4"
else
    #Change $1 to whatever the location is if you wanna hardcode it.
    packageLocation="$1"
fi


####Locate jamfHelper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

if [ -f "${jamfHelper}" ]; then
    
    #Display a dialog box to locate the installer
    "${jamfHelper}" -windowType utility -title "Please locate a High Sierra Installer" -description "On the next screen you'll need to select a 10.3.4 or higher High Sierra Installer. 
    
    This can be on the disk or on a USB drive." -alignDescription justified -button1 "Ok" -defaultButton 1 > /dev/null
    
    HighSierraInstaller=`osascript -e 'tell app (path to frontmost application as Unicode text) to set new_file to POSIX path of (choose file with prompt "Select A High Sierra Installer" of type {"APP"})'  2> /dev/null`
    if [ $? = 1 ]; then
        exit 0
    fi
    #Block Screen
    "${jamfHelper}" -windowType fs -title "Erasing macOS" -alignHeading center -heading "Erasing macOS" -alignDescription center -description "This computer is now being erased and is locked until rebuilt" -icon /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/Lock.jpg &
    
    #Run HS Installer, format and resetup the admin account, skipping all the setup, icloud, siri, etc
    "${HighSierraInstaller}"Contents/Resources/startosinstall --applicationpath "${HighSierraInstaller%?}" --agreetolicense --installpackage "${packageLocation}" --eraseinstall --nointeraction

    ps ax | grep "/Applications/Self Service.app" | awk '{print $1}' | xargs kill -9 2> /dev/null

else

    #Display a dialog box to locate the installer
    osascript -e 'Display dialog "On the next screen you will need to select a 10.3.4 or higher High Sierra Installer. This can be on the disk or on a USB drive." buttons {"Ok"} default button "Ok" with title "Please locate a High Sierra Installer"'
    HighSierraInstaller=`osascript -e 'tell app (path to frontmost application as Unicode text) to set new_file to POSIX path of (choose file with prompt "Select A High Sierra Installer" of type {"APP"})'  2> /dev/null`
    if [ $? = 1 ]; then
        exit 0
    fi

    if [ "${packageLocation}" = "" ]; then
        osascript -e 'Display dialog "Select the pkg to be installed Post Installation of High Sierra" buttons {"Ok"} default button "Ok" with title "Please locate a Post Install Installer"'
        packageLocation=`osascript -e 'tell app (path to frontmost application as Unicode text) to set new_file to POSIX path of (choose file with prompt "Select A Package" of type {"PKG"})'  2> /dev/null`
        if [ $? = 1 ]; then
            exit 0
        fi
    fi 

    #Run HS Installer with Admin Privs, format and resetup the admin account, skipping all the setup, icloud, siri, etc
    osascript -e "do shell script \"'${HighSierraInstaller}'Contents/Resources/startosinstall --applicationpath '${HighSierraInstaller%?}' --agreetolicense --installpackage '${packageLocation}' --eraseinstall --nointeraction\" with administrator privileges"
    
fi
