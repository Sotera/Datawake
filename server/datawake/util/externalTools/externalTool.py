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
from elasticsearch import Elasticsearch
from pykafka import KafkaClient
from datetime import datetime
import hashlib
import requests
import tangelo
import json
from tika import parser


def export_rest(service, domain_id, domain_name, cdr):
    try:
        protocol = 'http'
        if service['recipientProtocol']:
            protocol = service['recipientProtocol']
        url = '%s://%s' % (protocol, service['recipientUrl'])

        user = ''
        password = ''
        if service['credentials']:
            creds = service['credentials'].split(':')
            user = creds[0]
            password = creds[1]

        r = requests.put(url, data=cdr, auth=(user, password))
        tangelo.log('Sending page via REST put to: %s' % r.url)
        if r.status == 200:
            return True
    except Exception as e:
        tangelo.log_error("error sending via REST to: %s " % url, e)
        return False
    return False


def export_kafka(service, cdr):
    try:
        tangelo.log("sending kafka to %s %s" % (service['recipientUrl'], service['recipientIndex']))
        client = KafkaClient(hosts=service['recipientUrl'])

        topic = client.topics[service['recipientIndex']]
        producer = topic.get_producer()
        producer.produce(cdr)
    except Exception as e:
        tangelo.log_error("error sending via kafka to %s" % service['recipientUrl'], e)
        return False
    return True


def export_es(service, cdr, domain_name):
    try:
        protocol = 'http'
        cred = ''
        if service['recipientProtocol']:
            protocol = service['recipientProtocol']
        if service['credentials']:
            cred = service['credentials'] + '@'
        es_url = '%s://%s%s' % (protocol, cred, service['recipientUrl'])
        tangelo.log("sending ES at %s" % (es_url))
        tangelo.log("index: %s" % service['recipientIndex'])
        tangelo.log("doc_type: %s" % domain_name)
        tangelo.log("cdr: %s" % cdr)
        es = Elasticsearch(es_url)
        res = es.index(index=service['recipientIndex'], doc_type=domain_name, body=cdr)
        return res['created']
    except Exception as e:
        tangelo.log(e)
        tangelo.log_error("error sending via ES to %s" % service['recipientUrl'], e)
        return False
    return True


def build_cdr(url, content, entities, team_id, domain_id, trail_id, domain_name, user_email):
    crawl_time = datetime.now()
    id = hashlib.sha256('%s-%s' % (url, datetime.strftime(crawl_time, '%Y%m%d%H%M%s'))).hexdigest().upper()
    docid = 'dw-%i-%i-%i-%i' % (team_id, domain_id, trail_id, hash(url))
    soup = BeautifulSoup(content)
    # remove scripts and style
    for script in soup(["script", "style"]):
        script.extract()

    text = soup.get_text(strip=True).encode('ascii', 'ignore')

    parsed = parser.from_buffer(content)

    crawl_data = {'docid': docid, 'entities': entities, 'full-text': text, 'domain-name': domain_name,
                  'user-email': user_email}
    return json.dumps(dict(_id=id, _parent='', content_typ='text/html', crawl_data=crawl_data, crawler='datawake',
                team='sotera', extracted_metadata=parsed['metadata'], extracted_text=parsed['content'],
                raw_content=content, timestamp=datetime.strftime(crawl_time, '%Y%m%d%H%M%s'), url=url,
                version=2.0))
