
#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Extraction of phone numbers
"""
import re
import itertools
import math
import extractor

class ExtractPhoneNumber(extractor.Extractor):



    def human_name(self):
        return "simplephone"

    def name(self):
        return "phone"

    def version(self):
        return "0.0"

    def clean(self, bodyString):

        """
        Remove <script> tags and <style> tags
        """
        bodyString = re.sub('<script.*?>.*?</script>','',bodyString,flags=re.DOTALL)
        bodyString = re.sub(r'<style>.*?</style>','',bodyString,flags=re.DOTALL)

        """
        Remove text in between option tags
        """
        bodyString = re.sub('<option.*?</option>', '', bodyString)


        """
        Eliminate HTML tags for now
        """
        bodyString = re.sub(r'<.*?>', '', bodyString,flags=re.DOTALL)


        # Reove dates of the from xx/xx/xxxx
        bodyString = re.sub(r'\d{0,2}/\d{0,2}\d{0,4}','',bodyString,flags=re.DOTALL)
        # remove dates like 02, 2013
        bodyString = re.sub(r'\d{1,2}, \d{4}','',bodyString,flags=re.DOTALL)
        # remove times
        bodyString = re.sub(r'\d{1,2}:\d{2}','',bodyString,flags=re.DOTALL)


        """
        Eliminate UA tags in javascript for now too
        """

        bodyString = re.sub('(\'ua-[0-9]*-[0-9]*\')', '', bodyString)
        bodyString = re.sub('(href="[^"]*")', '', bodyString)
        bodyString = re.sub('(\d\'\d/\d\d\d?/\d\d)', '', bodyString)
        bodyString = re.sub('(\d\d?:\d\d-\d\d?:\d\d)', '', bodyString)
        bodyString = re.sub('(\d{2,3}(?:/)\d{2,3}(?:/)\d{2,3})(?=\D|$)', '', bodyString)
        bodyString = re.sub('(&#[0-9]{1,6}(?:\;)?)', '', bodyString)
        bodyString = re.sub('(value="^"*")', '', bodyString)



        bodyString = bodyString.replace('-','')


        return bodyString

    def extract(self, url, status, headers, flags, body, timestamp, source):
        if not body:
            return []

        bodyString = self.clean(body)
        # Finally get the phone numbers
        self.myCompiledRE = re.compile('[0-9]{7,14}')
        # remove whitespace
        bodyString = bodyString.replace('\t','').replace(' ','')
        pn =  self.myCompiledRE.findall(bodyString)

        phone_list = []
        for i in range(len(pn)):
            if len(pn[i]) == 10:
                phone_list.append(self.create_attribute(pn[i]))
        return phone_list

