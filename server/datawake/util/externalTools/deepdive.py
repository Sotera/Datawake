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
import requests
import tangelo
from bs4 import BeautifulSoup
from datawake.conf import datawakeconfig as conf

def export(team_id,domain_id,trail_id,url,content):

     docid = 'dw-%i-%i-%i-%i' %(team_id, domain_id, trail_id, hash(url))
     dd_url = '%s/%s/%s/'%(conf.get_deepdive_url(), conf.get_deepdive_user(), conf.get_deepdive_repo())

     soup = BeautifulSoup(content)
     # remove scripts and style
     for script in soup(["script", "style"]):
         script.extract()

     text = soup.get_text(strip=True).encode('ascii', 'ignore')

     headers = {'Authorization': 'Token %s' % conf.get_deepdive_token()}
     payload = {'docid': docid, 'doc_url': url, 'content': text }
     r = requests.post(dd_url, headers=headers, data=payload)
     tangelo.log('Sending page to deepdive at: %s' % r.url)

     return docid
