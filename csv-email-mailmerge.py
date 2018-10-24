#!/usr/bin/python

import os
import csv

#Read a text file that'll be the body of the message
#read a csv file that's in the format FULL_NAME, "TO EMAIL ADDRESS, CC EMAIL ADDRESS 1, CC EMAIL ADDRESS 2, etc"
#Puts it all together and emails out

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
	myCommand = "echo \"" + EmailBody + "\" | mail -s 'Please Come by the Tech Department' -c \""+ ParentEmails +"\" \""+ StudentEmail+"\""
	os.system(myCommand)
	print myCommand

EmailText.close()

	
	
	
