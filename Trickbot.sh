#!/bin/bash

#Script to grab the Trickbot IP addresses from the config and send them to a user for import into security appliances or firewalls. 
#You will need to create the trick.txt file in order for it to call the variable. You can find the most recent here:
#https://github.com/JR0driguezB/malware_configs/tree/master/TrickBot/mcconf_files
#Thank you to @JR0driguezB for the work on getting these 
#Variables
trick=$(cat ~/trick.txt)

#Web request to JR0driguezB github where he is hosting the config files for trickbot. 
curl https://raw.githubusercontent.com/JR0driguezB/malware_configs/master/TrickBot/mcconf_files/config.conf_$trick.xml > trickbot.txt

#Increment by 1 for the config files per his labeling.
trick=$(( trick + 1))

#Write back to the file for next run. 
echo $trick > trick.txt

#Grep for the IP addresses write out to file. 
cat trickbot.txt | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' > trickbot_ip.txt

#Email IOC's to email address. 
echo "" | mail -s "Trickbot IOCs ($day)" -A trickbot_ip.txt email address
