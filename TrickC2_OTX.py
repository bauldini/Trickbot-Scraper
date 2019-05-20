from OTXv2 import OTXv2
import json
import os


API_KEY = 'input your OTX key'
pulse_id= 'input your pulse ID'
OTX_SERVER = 'https://otx.alienvault.com'

otx = OTXv2(API_KEY, server=OTX_SERVER)

x = "/root/TrickBot/TrickC2.txt"


def get_c2():
    print 'Getting indicators for C2 pulse:'
    os.system('echo Getting IOCs from Trickbot C2 Pulse at $(date +%Y-%m-%d_%H:%M:%S)  >> /root/TrickBot/TrickBotC2.log')
    indicators = otx.get_pulse_indicators(pulse_id=pulse_id)
    json_out = open('/root/TrickBot/Trick_IP.json', 'a+')
    json_out.write('[')
    for indicator in indicators:
        file = open("/root/TrickBot/TrickC2.txt", 'a')
        file.write(indicator['indicator'])
        file.write("\n")
        file.close()


def outurl_json(x):
    with open(x , 'r') as in_file:
        json_out = open('/root/TrickBot/Trick_IP.json', 'a+')
        for line in in_file:
            obj = {u"type": "IPv4", u"indicator":  line.rstrip()}
            json_out.write(json.dumps(obj, indent=9))
            json_out.write(',\n')
        json_out.write(']')
        json_out.close()
        os.system('head -n -2 /root/TrickBot/Trick_IP.json | sed -e "\$a }\n" | sed -e "\$a ]" >> /root/TrickBot/Trick_IP2.json')


def update_pulse():
    print 'Updating indicators for C2 pulse:'
    os.system('echo Updating C2 Pulse at  $(date +%Y-%m-%d_%H:%M:%S) >> /root/TrickBot/TrickBotC2.log')
    with open('/root/TrickBot/Trick_IP2.json', 'r') as data_file:
        data = json.load(data_file)
        response = otx.replace_pulse_indicators(pulse_id, data)
        os.system('echo Done at $(date +%Y-%m-%d_%H:%M:%S) >> /root/TrickBot/TrickBotC2.log')
        #print 'Response: ' + str(response)


get_c2()
outurl_json(x)
update_pulse()
