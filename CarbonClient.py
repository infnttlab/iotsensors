#!/usr/bin/python
# -*- encoding: utf-8; py-indent-offset: 4 -*-

from time import time
from socket import socket

class CarbonClient:
    def __init__(self, host, port):
        self.sock = socket()
        self.sock.connect((host, port))

    def __del__(self):
        self.sock.close()

    def insert(self, path, value, timestamp=None):
        if not timestamp:
            timestamp = int(time())
        self.sock.sendall("%s %s %d\n" % (path, str(value), timestamp))


