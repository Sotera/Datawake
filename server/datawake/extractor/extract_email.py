#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Extraction of emails from ads
"""
import re
import extractor

class ExtractEmail(extractor.Extractor):

    def __init__(self):
        self.myCompiledRE = re.compile('([a-z,A-Z,0-9,\.,_,\-]+@[a-z,A-Z,0-9,_,\-]+\.[a-z,A-Z,0-9,_,\-,\.]+)')

    def human_name(self):
        return "istresearch"

    def name(self):
        return "email"

    def version(self):
        return "1.0"

    def extract(self, url, status, headers, flags, body, timestamp, source):
        if not body:
            return []

        body = body.lower()
        email = self.myCompiledRE.findall(body)
        email = list(set(email))
        email_list = []

        if email is not None:
            for e in email:
                email_list.append(self.create_attribute(e))

        return email_list
