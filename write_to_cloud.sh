#!/usr/bin/python
import sys, time, httplib, urllib, time
from CarbonClient import CarbonClient
from twitter import *

#Con la seguente routine si crea il problema del newline a fine elemento del vettore, meglio come sotto
#with open("/tmp/power", "r") as ins:
#    Powerarray = []
#    for line in ins:
#        Powerarray.append(line)


Powerarray = open("/tmp/power.temp").read().splitlines()

totalPower = float(Powerarray[0])
itPower = float(Powerarray[1])
chillerPower = float(Powerarray[2])
pue = float(Powerarray[3])
block1Room1Power = float(Powerarray[4])
block2Room1Power = float(Powerarray[5])
block3Room1Power = float(Powerarray[6])
block1Room2Power = float(Powerarray[7])
block2Room2Power = float(Powerarray[8])
block3Room2Power = float(Powerarray[9])
block4Room2Power = float(Powerarray[10])
garrRoomPower = float(Powerarray[11])
gridRoomPower = float(Powerarray[12])
libRoomPower = float(Powerarray[13])
probe1ExternalTemp = float(Powerarray[14])
probe1Room1Temp = float(Powerarray[15])
probe2Room1Temp = float(Powerarray[16])
probe1Room2Temp = float(Powerarray[17])
probe2Room2Temp = float(Powerarray[18])
probe1GarrroomTemp = float(Powerarray[19])
probe1PowerroomTemp = float(Powerarray[20])
probe1TransformersroomTemp = float(Powerarray[21])

maxRoom1Temp=max(probe1Room1Temp, probe2Room1Temp)
maxRoom2Temp=max(probe1Room2Temp, probe2Room2Temp)

#pue = totalPower/itPower
itPowerRoom1 = float(block1Room1Power) + float(block2Room1Power) + float(block3Room1Power)
itPowerRoom2 = float(block1Room2Power) + float(block2Room2Power) + float(block3Room2Power) + float(block4Room2Power)

print "POWER"
print "Total power:", totalPower
print "IT  power:", itPower
print "Chiller  power:", chillerPower
print "PUE:", pue
print "Room1 power:", block1Room1Power, block2Room1Power, block3Room1Power, "(",itPowerRoom1,")"
print "Room2 power:", block1Room2Power, block2Room2Power, block3Room2Power, block4Room2Power, "(", itPowerRoom2, ")"
print "Garr room power:", garrRoomPower
print "Grid room power:", gridRoomPower
print "Library room power:", libRoomPower
print
print "TEMPERATURE"
print "External temperature", probe1ExternalTemp
print "Room 1 temperature", probe1Room1Temp, probe2Room1Temp
print "Room 1 max temperature", maxRoom1Temp
print "Room 2 temperature", probe1Room2Temp, probe2Room2Temp
print "Room 2 max temperature", maxRoom2Temp
print "Garr room temperature", probe1GarrroomTemp
print "Power room temperature", probe1PowerroomTemp
print "Transformers room temperature", probe1TransformersroomTemp

#To Twitter
config = {}
execfile("/root/iotsensors/config.py", config)
twitter = Twitter(auth = OAuth(config["access_key"], config["access_secret"], config["consumer_key"], config["consumer_secret"]))
#new_status = "Room 1 temp: %0.2f" %probe1Room1Temp+", %0.2f" %probe2Room1Temp + "\n"+"Room 2 temp: %0.2f" %probe1Room2Temp+", %0.2f" %probe2Room2Temp + "\n" +"Power room temp: %0.2f" %probe1PowerroomTemp+"\n"+"Garr room temp: %0.2f" %probe1GarrroomTemp+"\n"+"Trafo room temp: %0.2f" %probe1TransformersroomTemp+"\n"+"Ext temp: %0.2f" %probe1ExternalTemp
new_status = "Room 1 temp: %0.2f" %maxRoom1Temp+"\n"+"Room 2 temp: %0.2f" %maxRoom2Temp+"\n"+"Power room temp: %0.2f" %probe1PowerroomTemp+"\n"+"Garr room temp: %0.2f" %probe1GarrroomTemp+"\n"+"Trafo room temp: %0.2f" %probe1TransformersroomTemp+"\n"+"Ext temp: %0.2f" %probe1ExternalTemp
results = twitter.statuses.update(status = new_status)

params = urllib.urlencode({'field1': maxRoom1Temp, 'field2': maxRoom2Temp,'field3': probe1GarrroomTemp, 'field4': probe1PowerroomTemp,'field5': probe1TransformersroomTemp, 'field6': probe1ExternalTemp, 'key':config["id54267_write_key"]})
params2 = urllib.urlencode({'field1': totalPower, 'field2': itPower,'field3': chillerPower, 'field4': itPowerRoom1, 'field5': itPowerRoom2, 'key':config["id58525_write_key"]})
headers = {"Content-type": "application/x-www-form-urlencoded","Accept":  "text/plain"}
conn = httplib.HTTPConnection("api.thingspeak.com:80")
try:
        conn.request("POST", "/update", params, headers)
        response = conn.getresponse()
        data = response.read()
        conn.request("POST", "/update", params2, headers)
        response = conn.getresponse()
        data = response.read()
        conn.close()
except:
        print "connection failed"

