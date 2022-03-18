import serial.tools.list_ports
import json

ports = serial.tools.list_ports.comports()
serialInst = serial.Serial()

portList = []

for onePort in ports:
    portList.append(str(onePort))
    print(str(onePort))

#val = input("select Port: COM")
#print(val)

for x in range(0, len(portList)):
    if "Arduino" in portList[x]:
        portVar = portList[x]

print(portVar[0:4])

serialInst.baudrate = 2000000
serialInst.port = portVar[0:4]
serialInst.open()
count = 0

while True:
    if serialInst.in_waiting:
        count = count + 1
        packet = serialInst.readline()
        angleE = packet.decode('utf').rstrip('\r').rstrip('\n')
        print(packet.decode('utf').rstrip('\r').rstrip('\n'))
        packet2 = serialInst.readline()
        angleSX = packet2.decode('utf').rstrip('\r').rstrip('\n')
        print(packet2.decode('utf').rstrip('\r').rstrip('\n'))
        packet3 = serialInst.readline()
        angleSY = packet3.decode('utf').rstrip('\r').rstrip('\n')
        print(packet3.decode('utf').rstrip('\r').rstrip('\n'))
        packet4 = serialInst.readline()
        angleSZ = packet4.decode('utf').rstrip('\r').rstrip('\n')
        print(packet4.decode('utf').rstrip('\r').rstrip('\n'))

        output ={
            "Elbow" : float(angleE),
            "ShoulderX" : float(angleSX),
            "ShoulderY" : float(angleSY),
            "ShoulderZ" : float(angleSZ)
        }
        output_string = '{"sample": ' + str(count) + ', "angles": [' + str(angleE) + ',' + str(angleSX) + ',' + str(angleSY) + ',' + str(angleSZ) + ']}'
        o_dict = json.loads(output_string)
        json_object = json.dumps(o_dict, indent = 5)
        with open("jsonData.json", "w") as outfile:
            outfile.write(json_object)
        # Serializing json
        #json_object = json.dumps(output, indent = 4)

        # Writing to sample.json
        #with open("jsonData.json", "w") as outfile:
            #outfile.write(json_object)
