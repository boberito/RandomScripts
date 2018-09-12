#!/bin/sh

#Creates a csv with stats on how much downloaded from your MAU caching server
#Or will print out for a specific date

apacheAccessLog="/var/log/apache2/access_log"


if [ "$1" == "-h" ] || [ "$1" == "" ]; then
	echo "Input date dd/Month/yyyy - ex 09/Sep/2018"
	echo "-csv to create csv MAUDailtotal.csv"
	echo "-csv date to create on specific date or it will use current"
	exit 0
fi

if [ "$1" == "-csv" ]; then
	if [ "$2" == "" ]; then
		Yesterday=$(date -v -1d "+%d/%b/%Y")
		YesterdayDownload=$(cat "${apacheAccessLog}"  | grep "${Yesterday}" | grep ".pkg" | grep -v 404 | awk '{print $11}')

		total=0

		for clients in $YesterdayDownload; do
	
			let total=total+clients
	
		done
		printf "${Yesterday}," >> MAUdailytotal.csv
		awk -v var="$total" 'BEGIN {
			if ( var > 1073741824 )
				print var/1024/1024/1024,"GB"
			else
				print var/1024/102,"MB"

		}' >> MAUdailytotal.csv
	else
		Yesterday="$2"
		YesterdayDownload=$(cat "${apacheAccessLog}"  | grep "${Yesterday}" | grep ".pkg" | grep -v 404 | awk '{print $11}')

		total=0

		for clients in $YesterdayDownload; do
	
			let total=total+clients
	
		done
		printf "${Yesterday}," >> MAUdailytotal.csv
		awk -v var="$total" 'BEGIN {
			if ( var > 1073741824 )
				print var/1024/1024/1024,"GB"
			else
				print var/1024/102,"MB"

		}' >> MAUdailytotal.csv
	fi
else
	Yesterday="$1"
	YesterdayDownload=$(cat "${apacheAccessLog}"  | grep "${Yesterday}" | grep ".pkg" | grep -v 404 | awk '{print $11}')

	total=0

	for clients in $YesterdayDownload; do
	
		let total=total+clients
	
	done
	printf "${Yesterday} - "
	awk -v var="$total" 'BEGIN {
		if ( var > 1073741824 )
			print var/1024/1024/1024,"GB downloaded"
		else
			print var/1024/102,"MB downloaded"

	}' 
fi
