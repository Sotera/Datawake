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
from elasticsearch import Elasticsearch
import tangelo
from datawake.conf import datawakeconfig as conf


#
# Return the graph display options
#
def query(data):

    tangelo.log('domaindive:query')
    tangelo.log(data)

    # set default es options
    url = conf.FORENSIC_ES_URL
    indd = conf.FORENSIC_ES_INDEX
    max_results_per_node = conf.FORENSIC_ES_MRPN
    cred = conf.FORENSIC_ES_CRED
    protocol = 'https'

    # override defaults if supplied with query
    if 'protocol' in data and data['protocol'] in ['http','https']:
        protocol = data['protocol']
        if protocol != 'https': cred = None
    if 'url' in data and data['url'] is not None and len(data['url']) > 0:
        url = data['url']
        cred = None  # if the url changed reset the credentials
    if 'mrpn' in data and data['mrpn'] is not None: max_results_per_node = data['mrpn']
    if 'index' in data and data['index'] is not None and len(data['index']) >0: indd = data['index']
    if 'credentials' in data and data['credentials'] is not None and len(data['credentials']) >0: cred = data['credentials']


    tangelo.log('using elastic serach instance: '+protocol+"://"+url)

    search_terms = data['search_terms']
    es = None
    if cred is not None and len(cred) > 0:
        es = Elasticsearch([protocol+'://' + cred + '@' + url])
    else:
        es = Elasticsearch([url])

    ind = indd
    rr = []
    num = 0
    for t in search_terms:
        types = {'selection','phone','email','person','organization','misc'}
        if t['type'].lower() in types:
            num_to_search = t['id']
            if t['type'] == 'selection':
                num_to_search = t['data']
            #results = es.search(index=ind,body={"size":max_results_per_node,"fields":["_index","_type","_id"],"query":{"match_phrase": {"_all": num_to_search}}})
            results = es.search(index=ind,body={"size":max_results_per_node,"query":{"match_phrase": {"_all": num_to_search}}})
            num += results['hits']['total']
            for hit in results['hits']['hits']:
                tangelo.log(hit)
                rr.append({'nid':t['id'],'search_term':num_to_search,'eid':hit['_id'],'itype':hit['_type'],'jindex':ind,'url':url,'_source':hit['_source']})

    result = dict(num=num,hits=rr)
    tangelo.log(result)
    return json.dumps(result)

def indices():
    url = conf.FORENSIC_ES_URL
    cred = conf.FORENSIC_ES_CRED
    protocol = 'https'
    if cred is not None and len(cred) > 0:
        es = Elasticsearch([protocol+'://' + cred + '@' + url])
    else:
        es = Elasticsearch([url])
    indices = Elasticsearch.cat.indices(h='i')
    return json.dumps([x.strip() for x in indices.split('\n')])





post_actions = {
    'query': query,
}

get_actions = {
    'indices': indices,
}


@tangelo.restful
def post(action, *args, **kwargs):
    post_data = json.loads(tangelo.request_body().read())

    def unknown(**kwargs):
        return tangelo.HTTPStatusCode(400, "invalid service call")

    return post_actions.get(action, unknown)(**post_data)

@tangelo.restful
def get(action, *args, **kwargs):
    def unknown(**kwargs):
        return tangelo.HTTPStatusCode(400, "invalid service call")

    return get_actions.get(action, unknown)(**kwargs)
