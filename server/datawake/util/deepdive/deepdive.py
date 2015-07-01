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

import tangelo
import requests

def export(team_id,domain_id,trail_id,url,content):

     docid = 'dw-%i-%i-%i-%i' %(team_id, domain_id, trail_id, hash(url))
     username='justin'
     repository='atf'
     url = 'https://api.clearcutcorp.com/docs/'+username+'/'+repository+'/'

     soup = BeautifulSoup(content)
     # remove scripts and style
     for script in soup(["script", "style"]):
         script.extract()

     text = soup.get_text(strip=True).encode('ascii', 'ignore')

     headers = {'Authorization': 'Token cac59b455cbdedc4c54d767c254b6cea2d8267da'}
     payload = {'docid': docid, 'doc_url': url, 'content': text }
     r = requests.post(url, headers=headers, data=payload)
     tangelo.log('Sending page to deepdive at: %s' % r.url)

     tangelo.log(r.json())
