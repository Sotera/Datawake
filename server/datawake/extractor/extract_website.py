#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Extraction of any link URLs from ads
"""
import re
import extractor
class ExtractWebsite(extractor.Extractor):

    valid = ['.info', '.com', '.in', '.net', \
             '.hk', '.ru', '.biz', '.org', '.sq', \
             '.us', '.uk', '.ca', '.mx', '.de', \
             '.fr', '.es', '.co', '.cz', '.nz', \
             '.gr', '.nl', '.phtml', '.htm']

    def __init__(self):
        self.complexRE = re.compile('((?:<a.*?href=\")(\S{3,100})\".*a> ((?:. )+)<a.*?(?:href=\")(\S{3,100})\")')
        self.easyRE = re.compile('(?:href=")(\S{3,100})(?=")')

    def human_name(self):
        return "istresearch"

    def name(self):
        return "website"

    def version(self):
        return "1.0"

    def extract(self, url, status, headers, flags, body, timestamp, source):
        if not body:
            return []

        #bodyString = body.lower()
        bodyString = body
        websites = self.easyRE.findall(bodyString)
        websites = list(set(websites))
        validUrls = []
        count = 0

        for i in range(len(websites)):
            site = websites[i]
            # get ending
            end= site.rfind('.')

            ending = site[end:]
            slash = ending.find('/')
            if slash != -1:
                ending = ending[:slash]

            if (not 'mailto' in site and not site.isdigit()) \
                    and len(ending) > 0 and ending in self.valid:
                validUrls.append(site)

        # try to find those urls with spaces between them like http://escort a d s.com
        trickySites = self.complexRE.findall(bodyString)
        trickyUrls = []
        trickyRaws = []
        for i in range(len(trickySites)):
            #print trickySites[i]
            # first part is beginning of url, second is spacing, third is ending
            raw = trickySites[i][0]
            part1 = trickySites[i][1]
            part2 = trickySites[i][2]
            part3 = trickySites[i][3]

            # remove bad ending from found hrefs
            if len(validUrls) > 0:
                for i in range(len(validUrls) - 1, -1, -1):
                    easyUrl = validUrls[i]
                    if easyUrl == part3:
                        validUrls.pop(i)

            # remove slashed endings
            while part1[-1:] == "\\" or part1[-1:] == '/':
                part1 = part1[:-1]

            part2 = part2.replace(' ', '')
            part3 = part3.replace('http://', '')

            #print "PARTS:", part1 + part2 + part3
            trickyUrls.append(part1 + part2 + part3)
            trickyRaws.append(raw)

        url_list = []
        for url in validUrls:
            url_list.append(self.create_attribute(url))

        for i in range(len(trickyUrls)):
            url_list.append(self.create_attribute(trickyUrls[i], trickyRaws[i]))

        return url_list