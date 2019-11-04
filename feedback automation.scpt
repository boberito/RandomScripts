--If you have problems or questions...i may or may not be able to help. Find me on slack @boberito or email me boberito@mac.com
--Must give access to Accessibility access for Script Editor or the application bundle.
--I decided it's safer to pile up the windows instead of automating the final submit, that way you can edit the ticket if changes are needed or more information is needed to be included.

--Reads in a csv in format title,section,type of feedback,body,yes/no
--if no it'll skip the system report business and submit without it.
--no return line at the end of the csv


--Must give access to 
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

set csvFile to (choose file with prompt "Select CSV file...") as text
set csvData to read file csvFile
set csvRecords to paragraphs of csvData

repeat with thisRecord in csvRecords
	set recordItems to my getItems(thisRecord)
	set Feedback_Title to item 1 of recordItems
	set area_issue to item 2 of recordItems
	set type_of_report to item 3 of recordItems
	set feedback to item 4 of recordItems
	set sys_report to item 5 of recordItems
	
	tell application "Feedback Assistant"
		activate
	end tell
	delay 3
	
	
	tell application "System Events"
		tell process "Feedback Assistant"
			set frontmost to true
			click menu item "New Feedback" of menu "File" of menu bar 1
			delay 1
			key code 125
			delay 1
			key code 76
			delay 2
			set value of text field 1 of scroll area 1 of window "Problem Report Draft" to Feedback_Title
			delay 2
			
			tell pop up button 1 of scroll area 1 of window "Problem Report Draft"
				click
				keystroke area_issue
				key code 76
			end tell
			tell pop up button 2 of scroll area 1 of window "Problem Report Draft"
				click
				keystroke type_of_report
				key code 76
			end tell
			set value of text area 1 of scroll area 1 of scroll area 1 of window "Problem Report Draft" to feedback
			click button "Continue" of window "Problem Report Draft"
			delay 1
			--			do shell script "echo \"continue\" >> /Users/Shared/log.txt"
			
			if sys_report is "no" then
				delay 2
				click button "Continue" of window 1
				--do shell script "echo \"button 4 pushed\" >> /Users/Shared/log.txt"
				click button "Submit" of window 1
				do shell script "echo \"submit pushed\" >> /Users/Shared/log.txt"
				--click button "Submit Without Files" of sheet 1 of window 1
				do shell script "echo \"submit without files\" >> /Users/Shared/log.txt"
				delay 2
			else
				do shell script "echo \"sys_report isnt equaling no\" >> /Users/Shared/log.txt"
				do shell script "while [[ $(ps aux | grep appleseed | grep -v grep) || $(ps aux | grep system_profiler | grep -v grep) ]]; do sleep 1; done"
				delay 2
				click button 4 of window 1
				delay 2
			end if
			
		end tell
	end tell
end repeat

on getItems(theRecord)
	copy the text item delimiters to origDelims
	set the text item delimiters to ","
	set recordItems to {}
	set recordItems to every text item of theRecord
	set the text item delimiters to origDelims
	return recordItems
end getItems
