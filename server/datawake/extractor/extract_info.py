#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
extraction of information using MIT-LL MITIE
"""


import re
import sys, os
import extractor

# import MITIE
if 'MITIE_HOME' not in os.environ:
    raise ValueError('MITIE_HOME not set.')


MITIE_HOME = os.environ['MITIE_HOME']
sys.path.append(MITIE_HOME+'/mitielib')

from mitie import *
from collections import defaultdict
from bs4 import BeautifulSoup

MIN_LEN = 5

class ExtractInfo(extractor.Extractor):

    def human_name(self):
        return "mitieinfo"

    def name(self):
        return "info"

    def version(self):
        return "0.0"



    myName = "info"




    def __init__(self):
        self.ner = named_entity_extractor(MITIE_HOME+'/MITIE-models/english/ner_model.dat')

    def extract(self, url, status, headers, flags, body, timestamp, source):

        soup = BeautifulSoup(body)
        tokens = tokenize(soup.get_text().encode('ascii', 'ignore'))
        entities = self.ner.extract_entities(tokens)
        #print entities
        ents = {}
        for e in entities:
            range = e[0]
            tag = e[1]
            entity_text = " ".join(tokens[i] for i in range)
            if len(entity_text) < MIN_LEN:
                continue
            txt = tag + ' -> ' + entity_text
            if ents.get(txt) == None:
                ents[txt] = 0
            ents[txt] += 1
        ent_array = ents.keys()
        ent_set = list(set(ent_array))
        feature_list = map(lambda x: self.create_attribute(x),ent_set)
        return feature_list