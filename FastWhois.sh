#!/bin/bash
#Super fast whois lookup - Jamin B http://skizzlesec.com/
echo Enter the file you want to read in:
read file
echo Spawn into how many threads?
read splitNumber
totalLines=`<$file wc -l` #determine the total number of lines
currentLine=0
currentFile=0
splitSize=$(($totalLines/$splitNumber))
echo Each file will contain $splitSize IPs.
rm -rf tmpdir
mkdir tmpdir
rm -rf whois
mkdir whois
cat $file | while read line
do
 (( currentLine = currentLine +1))
 if [ $(($currentLine%$splitSize)) == 0 ]; then
 (( currentFile = currentFile + 1))
 clear
 echo Creating file $currentFile in tmpdir
 cat /proc/meminfo | grep MemFree
 fi
 echo $line >> tmpdir/$currentFile
done
i=0
while [ $i -lt $splitNumber ]; do
 (( i = i + 1 ))
 clear
 echo Spawning process for file number $i
 cat tmpdir/$i | while read line
 do
 whois $line > whois/$line.txt &
 done
done
