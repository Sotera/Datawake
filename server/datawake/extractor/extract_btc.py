#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Extraction of bitcoin from ads
"""
import re
import extractor
import codecs
from hashlib import sha256

digits58 = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'

def to_bytes(n, length):
    s = '%x' % n
    s = s.rjust(length*2, '0')
    s = codecs.decode(s.encode("UTF-8"), 'hex_codec')
    return s

def decode_base58(bc, length):
    n = 0
    for char in bc:
        n = n * 58 + digits58.index(char)
    return to_bytes(n, length)
#http://rosettacode.org/wiki/Bitcoin/address_validation#Python
def check_bc(bc):
    try:
        bcbytes = decode_base58(bc, 25)
        return bcbytes[-4:] == sha256(sha256(bcbytes[:-4]).digest()).digest()[:4]
    except TypeError, e:
        return False

class ExtractBtc(extractor.Extractor):

    def __init__(self):
        self.myCompiledRE = re.compile('[13][a-km-zA-HJ-NP-Z1-9]{25,34}')

    def human_name(self):
        return "btc-extractor"

    def name(self):
        return "Bitcoin Address"

    def version(self):
        return "1.0"

    def extract(self, url, status, headers, flags, body, timestamp, source):
        if not body:
            return []
        btc = self.myCompiledRE.findall(body)
        btc = list(set(btc))
        btc_list = []

        if btc is not None:
            for e in btc:
                # Validate that this is a valid BTC address, the regex is unreliable
                # especially if the page contains any encryption artifacts like
                # pgp keys
                if check_bc(e):
                    btc_list.append(self.create_attribute(e))
        return btc_list
