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
import requests.exceptions
import tangelo
from datawake.conf import datawakeconfig as conf

def export(domain, payload):
    dig_url = conf.get_dig_url()
    payload['domain'] = domain
    try:
        response = requests.post(dig_url, data=payload)
        respone.raise_for_status()
    except :
        tangelo.log('Error submitting CDR object to Dig')
