#! /usr/bin/env python3

import binascii

with open("/dev/urandom", "rb") as fd:
    data = fd.read(20)

print("Change-Id: I{}".format(binascii.hexlify(data).decode('iso8859-1')))
