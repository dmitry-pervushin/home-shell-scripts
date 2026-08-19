#!/usr/bin/env python3
from Phidget22.PhidgetException import *
from Phidget22.Phidget import *
from Phidget22.Devices.DigitalOutput import *
import time
import socketserver
from daemonize import Daemonize
import logging

import sys


def configure_log(pylog=None, level=0):

    log = logging.getLogger('phidgets-server')

    ch = logging.StreamHandler(pylog or sys.stderr)
    ch.setFormatter(logging.Formatter(
        '[%(levelname)-1.1s] %(asctime)s %(message)-s'))
    log.addHandler(ch)
    ch.setLevel(level)
    log.setLevel(logging.DEBUG)
    return log


class Phidgets:
    def __init__(self):
        self.channels = {}
        for ch in ['0', '1', '2', '3']:
            self.channels[ch] = DigitalOutput()
            self.channels[ch].setChannel(int(ch))
            self.channels[ch].openWaitForAttachment(5000)

    def __del__(self):
        for (_, v) in list(self.channels.items()):
            v.close()

    def run(self, k):
        args = k.split()
        if args[0] == 'help':
            return "Use command like: <channel> up|down\n\tExample: 2 down\n\tCommands are case-sensitive!\n"

        if len(args) != 2:
            return ("Incorrect string %s\n" % k)

        if args[0] not in list(self.channels.keys()):
            return ("Channel %s is bad\n" % args[0])

        if args[1] not in ['down', 'up', 'nothing']:
            return ("Operation '%s' is bad\n" % args[1])

        action = "NOTHING"
        if args[1] != 'nothing':
            b, action = (1, "UP") if args[1] == 'up' else (0, "DOWN")
            c = self.channels[args[0]]
            c.setState(b)
        return ("OK: %s %s [ch=%d state=%s]\n" % (args[0], action, c.getChannel(), c.getState()))


class PhidgetHandler(socketserver.BaseRequestHandler):
    def handle(self):
        log = logging.getLogger('phidgets-server')
        try:
            i = self.request.recv(1024)
            i = i.strip()
        except:
            i = None
        log.info("Received '%s'", i)
        if i:
            r = self.server.phidgets.run(i.decode())
        else:
            r = "Unknown '%s'" % i
        self.request.sendall(r.encode(encoding='ascii'))


def main(port=9998, log=None):
    log.info("Starting...")
    server = socketserver.TCPServer(('', port), PhidgetHandler)
    server.phidgets = Phidgets()
    try:
        server.serve_forever()
    except:
        pass
    log.info("Shutdown...")
    server.shutdown()


class args:
    def __init__(self):
        self.port = 9999
        self.debug = False
        self.loglevel = logging.DEBUG


a = args()
a.port = 9900
a.debug = not False

pylog = open("/var/log/phidgets.log", "a")
L = configure_log(pylog, a.loglevel)
Daemonize(app="phidgets",
          action=lambda: main(a.port, L),
          pid="/var/run/phidgets.pid",
          keep_fds=[pylog.fileno()],
          logger=L,
          foreground=a.debug).start()
