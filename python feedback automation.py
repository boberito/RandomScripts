#!/usr/bin/env python3
# This script takes input from the macOS Security Compliance Project.
# Requires pyyaml package
# Requires Terminal to have Accessibility access in Security & Privacy
# It will parse the rule files and generate Feedback and AppleCare Enterprise tickets for rules that are not controlled by Configuration Profile.
# Options to run with this script
# -h, help
# -s, submit to auto submit Feedback tickets
# -a, create email to Applecare - currently only works with Apple Mail
# Point the script to a folder within rules folder and have fun submitting feedback and tickets!
# For example run it ./pyAScript.py /macos_security/rules/os -a "support email @ apple.com" -s Yes or -s No

import argparse
import sys
import os
import os.path
import yaml
import glob
import re
import warnings
import subprocess
from pathlib import Path
from subprocess import Popen, PIPE

def applescripty(auto, email, title, section, feedbackType, feedback, sysreport):
    scrpt = '''
    on run {{x}}
        
tell application "System Events"
	if UI elements enabled is false then
		tell application "System Preferences"
			activate
			set current pane to pane id "com.apple.preference.security"
			display dialog "This script requires access for assistive devices be enabled." & return & return & "To continue, click the OK button and allow Accessiblity in the Privacy tab" with icon 1
		end tell
		delay 1
	end if
end tell

set autoSubmit to "{}"
set applecareEmail to "{}"


tell application "Feedback Assistant"
    activate
end tell

delay 5

tell application "System Events"
	tell process "Feedback Assistant"
		set frontmost to true
		click menu item "New Feedback" of menu "File" of menu bar 1
		delay 1
		--		key code 125
		delay 1
		key code 76
		delay 2
		-- set value of text field 1 of scroll area 1 of window "Problem Report Draft" to item 1 of myList
		set value of text field 1 of scroll area 1 of window 1 to "{}"
		delay 4
		-- tell pop up button 1 of scroll area 1 of window "Problem Report Draft"
		tell pop up button 1 of scroll area 1 of window 1
			click
			keystroke "{}"
			-- arg2
			key code 76
		end tell
		--tell pop up button 2 of scroll area 1 of window "Problem Report Draft"
		tell pop up button 2 of scroll area 1 of window 1
			click
			keystroke "{}"
			--arg 3
			key code 76
		end tell
		-- set value of text area 1 of scroll area 1 of scroll area 1 of window "Problem Report Draft" to item 4 of myList
		set value of text area 1 of scroll area 1 of scroll area 1 of window 1 to x
		--click button "Continue" of window "Problem Report Draft"
		delay 3
		click button "Submit" of window 1
		set value of text field 1 of scroll area 1 of window 1 to "{}"
		click button "Submit" of window 1
		if autoSubmit is equal to "yes" then
			delay 2
			if "{}" is equal to "no" then
				
				click button "Submit Without Required Files" of sheet 1 of window 1
				
				
				delay 2
			else
				click button "Gather Diagnostics and Submit" of sheet 1 of window 1
                delay 2
			end if
		end if
		
	end tell

    if applecareEmail is not equal to "none" then
        tell application "Mail"
            set theSubject to "Priority: Low. {} - {}"
            set theMessage to make new outgoing message with properties {{subject:theSubject, content:x, visible:true}}
            tell theMessage
                make new to recipient with properties {{address:applecareEmail}}
            end tell
        end tell
    end if

end tell
end run
    '''.format(auto.lower(),email,title,section,feedbackType, title, sysreport.lower(), feedbackType, title)

    # print(scrpt)
    # print()
    # print("--------------------------------")
    # print()
    args = [feedback]
    p = Popen(['osascript', '-'] + args, stdin=PIPE, stdout=PIPE, stderr=PIPE, universal_newlines=True)
    stdout, stderr = p.communicate(scrpt)
    print(stdout)
    print(stderr)
    # print (p.returncode, stdout, stderr)

def main():
    defaultsWrite = 'defaults write com.apple.appleseed.FeedbackAssistant Autogather -bool NO'.split()
    subprocess.call(defaultsWrite)
    defaultsWrite = 'defaults write com.apple.appleseed.FeedbackAssistant FBASuppressPrivacyNotice -bool YES'.split()
    subprocess.call(defaultsWrite)
    section = "Client Management"
    feedbackType = "Suggestion"
    sysreport = "no"

    def dir_path(string):
        if os.path.isdir(string):
            return string
        else:
            raise NotADirectoryError(string)

    home = str(Path.home())

    parser = argparse.ArgumentParser(description='Create Feedback for non Profile rules')
    parser.add_argument("rules", default=None, help="Set of rules to create feedback from", type=dir_path)
    parser.add_argument("-s", "--submit", default="No", help="Auto Submit feedback tickets")
    parser.add_argument("-a", "--applecare", default="none", help="Enter Applecare Enterprise email address")
    
    try:
        results = parser.parse_args()
        print(results)
        print("Yaml rules folder: " + results.rules)
        print("Auto submit: " + results.submit)
        print("Applecare email: " + results.applecare)
        print()


    except IOError as msg:
        parser.error(str(msg))

    for rule in glob.glob(results.rules + '/*'):
        if "srg" in rule or "supplemental" in rule:
            continue
        with open(rule) as r:
            rule_yaml = yaml.load(r, Loader=yaml.SafeLoader)
        if "inherent" in rule_yaml['tags'] or "n_a" in rule_yaml['tags'] or "permanent" in rule_yaml['tags']:
            continue
        if "manual" in rule_yaml['tags']:
            
            continue
        if rule_yaml['mobileconfig']:
            continue
        
        subject = rule_yaml['title'] + " Configuration Profile request"
        description = '''
This is a compliance request that affects everyone that allows Macs in regulated industry such as government, healthcare, energy, banking. 

{}

Currently you must do the following fix:

{}

and to check compliance with the following:

{}

This not ideal for management and as MDM controls and configuration profile keys are implemented elsewhere in the system this would be a very valuable control to be implemented.  A control through MDM would make it easier to follow the NIST 800-53 {}.

By using MDM and configuration profiles to facilitate this control we reduce user error generated through the use of shell scripts. We improve the overall security of the device by making the MDM server the authoritative source for policy control on the device. Overall it makes it easier to manage and makes security policy resilient through software updates and upgrades.

Thank you
-- 

        '''.format(rule_yaml['discussion'].replace("_MUST_", "MUST"), rule_yaml['fix'], rule_yaml['check'], str(rule_yaml['references']['800-53r4']).replace("[","").replace("]",""))
        
        print(rule_yaml['id'])
        applescripty(results.submit, results.applecare, subject,section,feedbackType,description,sysreport)

    defaultsWrite = 'defaults write com.apple.appleseed.FeedbackAssistant Autogather -bool YES'.split()
    subprocess.call(defaultsWrite)
if __name__ == "__main__":
    main()
