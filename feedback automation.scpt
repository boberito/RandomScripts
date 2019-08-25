tell application "System Events"
	if UI elements enabled is false then
		tell application "System Preferences"
			activate
			set current pane to pane id "com.apple.preference.security"
			display dialog "This script requires access for assistive evices be enabled." & return & return & "To continue, click the OK button and allow Accessiblity in the Privacy tab" with icon 1
		end tell
		delay 1
	end if
end tell

set Feedback_Title to "My title"

set app_name to "Feedback Assistant"
set area_issue to "Mail"
set type_of_report to "Suggestion"
set feedback to "My great feedback"

tell application app_name
	activate
end tell
delay 2
tell application "System Events"
	tell process app_name
		set frontmost to true
		click menu item "New Feedback" of menu "File" of menu bar 1
		delay 1
		key code 125
		delay 1
		key code 76
		delay 2
		key code 48
		delay 5
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
	end tell
end tell
