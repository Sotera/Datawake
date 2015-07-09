"""
Copyright 2014 Sotera Defense Solutions, Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
"""

import json
from bs4 import BeautifulSoup
from datawake.conf import datawakeconfig as conf
from elasticsearch import Elasticsearch


import tangelo
import requests
import time

def export(url,content, crawl_data):

    creds = conf.FORENSIC_ES_CRED
    es_url = 'https://' + creds + '@' + conf.FORENSIC_ES_URL
    es = Elasticsearch(es_url)

    soup = BeautifulSoup(content)
    # remove scripts and style
    for script in soup(["script", "style"]):
        script.extract()

    text = soup.get_text(strip=True).encode('ascii', 'ignore')
    crawl_data['full-text'] = text
    payload = {'url': url, 'timestamp': int(time.time())*1000, 'team': 'sotera', 'crawler': 'datawake', 'content-type': 'full-raw-html', 'raw_content': content, 'crawl_data': crawl_data, 'images':'','videos':''}
    res = es.index(index="memex-domains", doc_type='weapons', body=payload)
