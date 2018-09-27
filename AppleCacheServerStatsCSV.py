#!/usr/bin/python
##################################################################
#Makes a CSV of the total amount served, cached served, and downloaded from apple
#Make a launchdaemon for it to run right after midnight sometime.
##################################################################

import subprocess
import StringIO
from datetime import date, timedelta

def sizeConvert(label,size):
    if label == "bytes":
        if size == "0":
            return 0
        else:
            return (float(size)/1024/1024/1024)
    if label == "KB":
        return (float(size)/1024/1024)
    if label == "MB":
        return (float(size)/1024)
    if label == "GB":
        return float(size)
    
outputfile = open("/Users/Shared/output.csv", "a")

command = "log show  --predicate \'subsystem == \"com.apple.AssetCache\"\' --debug --info --start \"$(date -v -1d \"+%Y-%m-%d\")\" --end \"$(date \"+%Y-%m-%d\")\" | grep \"Served all\""
cacheoutput = subprocess.check_output(command, shell=True)
rawLog = StringIO.StringIO(cacheoutput)

total = 0
localcache = 0
appledownload = 0

for x in rawLog:
    linesplit = str.split(x)
    total = total + sizeConvert(linesplit[16][:-1], linesplit[15])
    localcache = localcache + sizeConvert(linesplit[18],linesplit[17])
    appledownload = appledownload + sizeConvert(linesplit[22],linesplit[21])
    
yesterday = date.today() - timedelta(1)
yesterday.strftime('%Y-%m-%d')

output = "%s, %.2f,%.2f,%.2f\n" % (yesterday, round(total,2), round(localcache,2), round(appledownload,2))
outputfile.write(output)
outputfile.close()
