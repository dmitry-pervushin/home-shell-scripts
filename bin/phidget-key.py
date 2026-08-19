#!/usr/bin/env python

from ctypes import *
import sys
import random
#Phidget specific imports
from Phidgets.PhidgetException import PhidgetErrorCodes, PhidgetException
from Phidgets.Events.Events import AttachEventArgs, DetachEventArgs, ErrorEventArgs, InputChangeEventArgs, OutputChangeEventArgs, SensorChangeEventArgs
from Phidgets.Devices.InterfaceKit import InterfaceKit
from Phidgets.Phidget import PhidgetLogLevel

verbs = {
   'recovery' : 0,
   'reset'    : 1,
   'power'    : 3
}

onoff = {
   'on' : True,
   'off' : False,
   'yes' : True,
   'no' : False,
   '1'  : True,
   '0'   : False
}

if sys.argv[1] == "-":
	get = True
else:
	index = verbs[sys.argv[1]]
	state = onoff[sys.argv[2]]
	get = False

#Create an interfacekit object
interfaceKit = InterfaceKit()
interfaceKit.openPhidget()
interfaceKit.waitForAttach(10000)
if get:
	for a in verbs.keys():
		print "%-10.10s: %s" % (a, interfaceKit.getOutputState(verbs[a]))
else:
	interfaceKit.setOutputState(index, state)
interfaceKit.closePhidget()
