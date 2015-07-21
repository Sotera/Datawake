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

from bs4 import BeautifulSoup
from datawake.conf import datawakeconfig as conf
from elasticsearch import Elasticsearch
from pykafka import KafkaClient
from pykafka import KafkaException

import requests
import time

def export_rest(service_url, service_cred, service_index,domain, cdr, domain_name):

    headers = {'Authorization': 'Token %s' % conf.get_deepdive_token()}
    payload = {'docid': docid, 'doc_url': url, 'content': text }
    r = requests.post(dd_url, headers=headers, data=payload)
    tangelo.log('Sending page to deepdive at: %s' % r.url)
    if r.status == 200:
        return True
    else:
        return False


def export_kafka(service_url, service_index, cdr):
    try:
        client = KafkaClient(hosts=service_url)
        topic = client.topics[service_index]
        producer = topic.get_producer()
        producer.produce(cdr)
    except KafkaException, e:
        return False
    return True


def export_es(service_url, service_cred, service_index,cdr, domain_name):
    es_url = 'https://%s@%s' % (service_cred, service_url)
    es = Elasticsearch(es_url)
    res = es.index(index=service_index, doc_type=domain_name, body=cdr)
    return res['created']




def build_cdr(url, content, entities, team_id, domain_id, trail_id, domain_name,):
    docid = 'dw-%i-%i-%i-%i' %(team_id, domain_id, trail_id, hash(url))
    soup = BeautifulSoup(content)
    # remove scripts and style
    for script in soup(["script", "style"]):
        script.extract()

    text = soup.get_text(strip=True).encode('ascii', 'ignore')
    crawl_data = {'docid': docid, 'entities': entities, 'full-text': text, 'domain-name': domain_name}
    return {'url': url, 'timestamp': int(time.time())*1000, 'team': 'sotera', 'crawler': 'datawake', 'content-type': 'full-raw-html', 'raw_content': content, 'crawl_data': crawl_data, 'images':'','videos':''}

