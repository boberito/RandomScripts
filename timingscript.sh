#!/bin/sh

#enter a file location
#redirect the output to whatever.csv
#now you have a sortable csv of the time it takes to run a bunch of scripts.

fileslocation="" 
allscripts=$(ls -l $fileslocation | awk '{print $9}')

for file in $allscripts; do
    #echo "----------------"
    #echo $file
    #commandtime=`(time /bin/sh "${fileslocation}/${file}") 2>&1 | grep real | tr "real" "Time: "`
    #echo $commandtime
    commandtime=`(time /bin/sh "${fileslocation}/${file}") 2>&1 | grep real | tr "real" ", "`
    printf "%s, %s\n" "$file" "$commandtime"
done
