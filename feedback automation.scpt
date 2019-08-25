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
			key code 48
			delay 3
			keystroke Feedback_Title
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
			key code 48
			key code 48
			key code 48
			keystroke feedback
			
			click button "Continue" of window "Problem Report Draft"
			delay 1
			do shell script "while [[ $(ps aux | grep appleseed | grep -v grep) || $(ps aux | grep system_profiler | grep -v grep) ]]; do sleep 1; done"
			delay 2
			
			click button 4 of window 1
			
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
