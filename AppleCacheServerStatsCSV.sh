#!/bin/sh

##################################################################
#Makes a CSV of the amount served and downloaded from apple and date
#Make a launchdaemon for it to run right after midnight sometime.
##################################################################

YesterdayDate=$(date -v -2d "+%Y-%m-%d")
TodayDate=$(date -v -1d "+%Y-%m-%d")
YesterdayCacheLog=$(log show  --predicate 'subsystem == "com.apple.AssetCache"' --debug --info | grep "returned to clients" | grep "${YesterdayDate}" | tail -1 | awk '{ print $16 }')
YesterdayfromApple=$(log show  --predicate 'subsystem == "com.apple.AssetCache"' --debug --info | grep "returned to clients" | grep "${YesterdayDate}" | tail -1 | awk '{ print $29 }')
TodayCacheLog=$(log show  --predicate 'subsystem == "com.apple.AssetCache"' --debug --info | grep "returned to clients" | grep "${TodayDate}" | tail -1 | awk '{ print $16 }')
TodayfromApple=$(log show  --predicate 'subsystem == "com.apple.AssetCache"' --debug --info | grep "returned to clients" | grep "${TodayDate}" | tail -1 | awk '{ print $29 }')

printf "${TodayDate}," >> /Users/Shared/MacCachedailytotal.csv
awk -v YesterdayTotal="$YesterdayCacheLog" -v TodayTotal="$TodayCacheLog" -v YesterdayApple="$YesterdayfromApple" -v TodayApple="$TodayfromApple" 'BEGIN {
	print TodayTotal-YesterdayTotal,",",TodayApple-YesterdayApple
}' | tr -d " " >> /Users/Shared/MacCachedailytotal.csv

