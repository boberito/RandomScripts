--Version 2.0!
--If you have problems or questions...i may or may not be able to help. Find me on slack @boberito or email me boberito@mac.com
--Must give access to Accessibility access for Script Editor or the application bundle.
--I decided it's safer to pile up the windows instead of automating the final submit, that way you can edit the ticket if changes are needed or more information is needed to be included.

--2.0
--Reads in an excel sheet(title,section,type of feedback, body, yes/no). Switched from psuedo csv to excel so you can have commas and line breaks in the body of the text
--prompts to auto submit feedbacks
--prompts to open apple enterprise support case with the same info. (Apple Mail required currently)

--1.0
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

set theDialogText to "Auto submit Feedback in Feedback.app?"
set autoSubmit to (display dialog theDialogText buttons {"Yes", "No"} default button "No")

set theDialogText to "Open Applecare Enterprise support ticket?"
set aceTicket to (display dialog theDialogText buttons {"Yes", "No"} default button "Yes")

set applecareEmail to ""
log aceTicket
if aceTicket = {button returned:"Yes"} then
	set applecareEmail to text returned of (display dialog "Enter Applecare Enterprise email to open tickets" default answer "")
end if


repeat
	set dialogResult to (display dialog "How many feedback rows are in the Excel Document?" default answer "")
	try
		set iCellCount to (text returned of dialogResult) as integer
		exit repeat
	end try
	display dialog "The starting number needs to be a valid integer!" buttons {"Enter again", "Cancel"} default button 1
end repeat

set iCellCount to iCellCount + 1
set RowList to {"A", "B", "C", "D", "E"}
set i to 1
set SheetName to "Sheet1"

tell application "Microsoft Excel"
	set excelFile to (choose file with prompt "Excel File pls") as text
	open excelFile
	repeat while i < iCellCount
		set myList to {}
		repeat with rowItem in RowList
			set end of myList to (value of range (rowItem & i) of worksheet SheetName of workbook 1) as text
		end repeat
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
				set value of text field 1 of scroll area 1 of window "Problem Report Draft" to item 1 of myList
				delay 4
				tell pop up button 1 of scroll area 1 of window "Problem Report Draft"
					click
					keystroke item 2 of myList
					key code 76
				end tell
				tell pop up button 2 of scroll area 1 of window "Problem Report Draft"
					click
					keystroke item 3 of myList
					key code 76
				end tell
				set value of text area 1 of scroll area 1 of scroll area 1 of window "Problem Report Draft" to item 4 of myList
				click button "Continue" of window "Problem Report Draft"
				delay 1
				if item 5 of myList is "no" then
					delay 2
					click button "Continue" of window 1
					if autoSubmit = {button returned:"Yes"} then
						click button "Submit" of window 1
						click button "Submit Without Files" of sheet 1 of window 1
						
					end if
					delay 2
				else
					do shell script "while [[ $(ps aux | grep appleseed | grep -v grep) || $(ps aux | grep system_profiler | grep -v grep) ]]; do sleep 1; done"
					delay 2
					click button 4 of window 1
					delay 2
				end if
			end tell
		end tell
		if aceTicket = {button returned:"Yes"} then
			tell application "Mail"
				set theSubject to "Priority: Low. " & item 1 of myList & " - " & item 3 of myList
				set theMessage to make new outgoing message with properties {subject:theSubject, content:item 4 of myList, visible:true}
				tell theMessage
					make new to recipient with properties {address:applecareEmail}
				end tell
			end tell
		end if
		tell application "System Events"
			tell process "Microsoft Excel"
				set frontmost to true
			end tell
		end tell
		set i to i + 1
	end repeat
end tell
