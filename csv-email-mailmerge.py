#!/usr/bin/python


import os
import csv

EmailText=open("EmailBody.txt","r")
reader = csv.reader(open('emaillist.csv', 'rU'), dialect=csv.excel_tab, quotechar='"')

for row in reader:
	EachEntry = ','.join(row)
	FullName = EachEntry.split(',')[0]
	FirstName = FullName.split(' ')[0]
	#print FirstName
	Emails = EachEntry.split(',"')[1]
	Emails = Emails.strip('"')
	#print Emails
	ParentEmails = Emails[Emails.find(', ')+1:]
	#print ParentEmails
	StudentEmail = Emails.split(',')[0]
	#print StudentEmail
	EmailBody = FirstName + ",\n" + EmailText.read()
	#print FirstName + "\n" + EmailBody.read()
	myCommand = "echo \"" + EmailBody + "\" | mail -s 'Please Come by St. Andrews Tech Department' -c \""+ ParentEmails +"\" \""+ StudentEmail+"\""
	os.system(myCommand)
	print myCommand

EmailText.close()

	
	
	
