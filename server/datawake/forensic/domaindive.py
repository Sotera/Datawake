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



#
# Return the graph display options
#
def query(data):
    tangelo.log('domaindive:query')
    tangelo.log(data)
    url = data['url']
    max_results_per_node = int(data['mrpn'])
    indd = data['index']
    cred = data['credentials']
    search_terms = data['search_terms']
    es = None
    if cred is not None and len(cred) > 0:
        es = Elasticsearch(['http://' + cred + '@' + url])
    else:
        es = Elasticsearch([url])

    ind = indd
    rr = []
    num = 0
    for t in search_terms:
        if t['type'] == 'selection' or t['type'] == 'phone' or t['type'] == 'email' or t['type'] == 'info':
            num_to_search = t['id']
            if t['type'] == 'selection':
                num_to_search = t['data']
            if t['type'] == 'info':
                num_to_search = t['id'].split('->')[1].strip()
            #results = es.search(index=ind,body={"size":max_results_per_node,"fields":["_index","_type","_id"],"query":{"match_phrase": {"_all": num_to_search}}})
            results = es.search(index=ind,body={"size":max_results_per_node,"query":{"match_phrase": {"_all": num_to_search}}})
            num += results['hits']['total']
            for hit in results['hits']['hits']:
                tangelo.log(hit)
                rr.append({'nid':t['id'],'search_term':num_to_search,'eid':hit['_id'],'itype':hit['_type'],'jindex':ind,'url':url,'_source':hit['_source']})

    result = dict(num=num,hits=rr)
    tangelo.log(result)
    return json.dumps(result)


post_actions = {
    'query': query,
}


@tangelo.restful
def post(action, *args, **kwargs):
    post_data = json.loads(tangelo.request_body().read())

    def unknown(**kwargs):
        return tangelo.HTTPStatusCode(400, "invalid service call")

    return post_actions.get(action, unknown)(**post_data)
