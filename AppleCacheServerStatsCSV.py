#!/usr/bin/python
##################################################################
#Makes a CSV of the date, total amount served, cached served, and downloaded from apple
#Make a launchdaemon for it to run right after midnight sometime.
##################################################################

import subprocess
import StringIO
from datetime import date, timedelta

outputfile = open("/Users/Shared/output.csv", "a")

command = "log show  --predicate \'subsystem == \"com.apple.AssetCache\"\' --debug --info --start \"$(date -v -1d \"+%Y-%m-%d\")\" --end \"$(date \"+%Y-%m-%d\")\" | grep \"Served all\""

cacheoutput = subprocess.check_output(command, shell=True)
rawLog = StringIO.StringIO(cacheoutput)

total = 0
localcache = 0
appledownload = 0

for x in rawLog:
    linesplit = str.split(x)
    if linesplit[16] == "bytes;":
        if linesplit[15] != "0":
            total = total + (float(linesplit[15])/1024/1024/1024)
    if linesplit[16] == "KB;":
        total = total + (float(linesplit[15])/1024/1024)
    if linesplit[16] == "MB;":
        total = total + (float(linesplit[15])/1024)
    if linesplit[16] == "GB;":
        total = total + float(linesplit[15])
    
    if linesplit[18] == "bytes":
        if linesplit[17] != "0":
            localcache = localcache + (float(linesplit[17])/1024/1024/1024)
    if linesplit[18] == "KB":
        localcache = localcache + (float(linesplit[17])/1024/1024)
    if linesplit[18] == "MB":
        localcache = localcache + (float(linesplit[17])/1024)
    if linesplit[18] == "GB":
        localcache = localcache + float(linesplit[17])
    
    if linesplit[22] == "bytes":
        if linesplit[21] != "0":
            appledownload = appledownload + (float(linesplit[21])/1024/1024/1024)
    if linesplit[22] == "KB":
        appledownload = appledownload + (float(linesplit[21])/1024/1024)
    if linesplit[22] == "MB":
        appledownload = appledownload + (float(linesplit[21])/1024)
    if linesplit[22] == "GB":
        appledownload = appledownload + float(linesplit[21])

yesterday = date.today() - timedelta(1)
yesterday.strftime('%Y-%m-%d')

output = "%s, %.2f,%.2f,%.2f\n" % (yesterday, round(total,2), round(localcache,2), round(appledownload,2))
outputfile.write(output)
outputfile.close()
