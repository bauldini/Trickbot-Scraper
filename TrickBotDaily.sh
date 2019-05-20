#!/bin/bash

#Variables
url="https://feodotracker.abuse.ch/downloads/ipblocklist.csv"
bulk="tracker.txt"
malware="TrickBot"
day=$(date +%Y-%m-%d)

#Remove previos days files
if ls /root/TrickBot/*.txt 1> /dev/null 2>&1;
then
        rm trickbot.txt inital_trick_c2.txt TrickBot.txt TrickC2.txt *.json
fi

#Get the new days CSV files
curl --insecure -o /root/TrickBot/$bulk $url

#Parse file for only the day of and Trickbot malware
cat /root/TrickBot/tracker.txt | grep $day | grep $malware > /root/TrickBot/TrickBot.txt

#Parse for only C2 and remove other infromation"
cat /root/TrickBot/TrickBot.txt | cut -d "," -f2 > /root/TrickBot/inital_trick_c2.txt

#Added functionality to remove duplicates in files. 
grep -vf /root/White/TrickWhiteC2.txt /root/TrickBot/inital_trick_c2.txt > /root/TrickBot/TrickC2.txt

echo "Bash Complete @ $(date +%Y-%m+%d)" >> /root/TrickBot/LastTrickBotC2.log

/usr/bin/python /root/TrickBot/Last_TrickBot_C2.py
