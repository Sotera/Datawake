#!/usr/bin/python
# -*- coding: utf-8 -*-
class Attribute():

    def __init__(self, attribute, value, extracted_metadata, extracted_raw = ""):
        '''
        @param attribute: The attribute name
        @param value: The value associated with the attribute
        @param extracted_raw: The original text where your attribute value pair was
            found (as minimal as possible)
        '''
        self.attribute = attribute
        self.value = value
        self.extracted_raw = extracted_raw
        self.extracted_metadata = extracted_metadata

    def to_list(self):
        '''
        @return: a list the attribute's data
        '''
        return [self.attribute, self.value, self.extracted_raw, self.extracted_metadata]

class Extractor:

    def __init__(self):
        '''
        Any massive precompilation tasks should go here
        '''
        pass

    def get_full_name(self):
        '''
        @return: the full name and version of the Extractor
        '''
        return self.human_name() + "." + self.name() + "_v" + self.version()

    def human_name(self):
        '''
        @return: the human readable proper beginning name of this extractor
        ie 'istresearch', 'sotera', or some other unique identifier
        '''
        raise NotImplementedError("Please implement humanName()")

    def name(self):
        '''
        @return: the name of the attribute being extracted
        '''
        raise NotImplementedError("Please implement name()")

    def version(self):
        '''
        The version number of the extractor being ran
        '''
        raise NotImplementedError("Please implement version()")

    def create_attribute(self, value, extracted_raw = ""):
        '''
        @param value: A single value found
        @param extracted_raw: The original text where that was found (small as possible)
        @return: An Attribute object
        '''
        return Attribute(self.name(), value, self.get_full_name(), extracted_raw)

    def extract(self, url, status, headers, flags, body, timestamp, source):
        '''
        This method is called to extract any data from a given webpage

        @param url: The url of the web page
        @param status: The return status code from the page
        @param headers: The headers returned from visiting the url
        @param flags: Any error flags raised by the scraper
        @param body: The main raw body of the web page
        @param timestamp: The time stamp of the visit
        @param source: The source site identifier
        @return: A list of AdAttributes objects (use create_attribute() method)
        '''
        raise NotImplementedError("Please implement extract()")