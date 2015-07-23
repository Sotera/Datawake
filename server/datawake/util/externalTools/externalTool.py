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

import requests
import tangelo
import time

def export_rest(service_url, service_cred, service_index, domain_id, domain_name, cdr):
    try:
        headers = {'Authorization': 'Token %s' % conf.get_deepdive_token()}
        payload = {'docid': docid, 'doc_url': url, 'content': text }
        r = requests.post(dd_url, headers=headers, data=payload)
        tangelo.log('Sending page to deepdive at: %s' % r.url)
        if r.status == 200:
            return True
    except Exception as e:
        tangelo.log_error("error sending via REST to: %s " % service_url, e)
        return False
    return False


def export_kafka(service_url, service_index, cdr):
    try:
        tangelo.log("sending kafka to %s %s" % (service_url, service_index))
        client = KafkaClient(hosts=service_url)

        topic = client.topics[service_index]
        producer = topic.get_producer()
        producer.produce(cdr)
    except Exception as e:
        tangelo.log_error("error sending via kafka to %s" % service_url,e)
        return False
    return True


def export_es(service_url, service_cred, service_index, cdr, domain_name):
    try:
        es_url = 'https://%s@%s' % (service_cred, service_url)
        tangelo.log("sending ES at %s" % (es_url))
        es = Elasticsearch(es_url)
        res = es.index(index=service_index, doc_type=domain_name, body=cdr)
        return res['created']
    except Exception as e:
        tangelo.log_error("error sending via ES to %s" % service_url,e)
        return False
    return True



def build_cdr(url, content, entities, team_id, domain_id, trail_id, domain_name, user_email):
    docid = 'dw-%i-%i-%i-%i' %(team_id, domain_id, trail_id, hash(url))
    soup = BeautifulSoup(content)
    # remove scripts and style
    for script in soup(["script", "style"]):
        script.extract()

    text = soup.get_text(strip=True).encode('ascii', 'ignore')
    crawl_data = {'docid': docid, 'entities': entities, 'full-text': text, 'domain-name': domain_name, 'user-email': user_email}
    return {'url': url, 'timestamp': int(time.time())*1000, 'team': 'sotera', 'crawler': 'datawake', 'content-type': 'full-raw-html', 'raw_content': content, 'crawl_data': crawl_data, 'images':'','videos':''}

