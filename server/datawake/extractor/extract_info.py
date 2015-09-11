#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
extraction of information using MIT-LL MITIE
"""

import cStringIO
import extractor
import eatiht.v2 as v2
import os
import re
import sys
from datawake.conf import datawakeconfig as conf


# import MITIE
MITIE_HOME = conf.get_mitie_home()
if not MITIE_HOME:
    raise ValueError('MITIE_HOME not set.')

sys.path.append(MITIE_HOME + '/mitielib')

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
        self.ner = named_entity_extractor(
            MITIE_HOME + '/MITIE-models/english/ner_model.dat')

    def extract(self, url, status, headers, flags, body, timestamp, source):

        contentStream = cStringIO.StringIO(body)
        text = v2.extract(contentStream).encode('utf-8')

        tokens = tokenize(text)
        entities = self.ner.extract_entities(tokens)

        ents = {}
        for e in entities:
            range = e[0]
            tag = e[1]
            entity_text = " ".join(tokens[i] for i in range)
            # Removing non-printable characters
            entity_text = filter(lambda x: x in string.printable, entity_text)
            if len(entity_text) < MIN_LEN:
                continue
            txt = tag + ' -> ' + entity_text
            if ents.get(txt) == None:
                ents[txt] = 0
            ents[txt] += 1
        ent_array = ents.keys()
        ent_set = list(set(ent_array))
        feature_list = map(lambda x: self.create_attribute(x), ent_set)
        return feature_list
