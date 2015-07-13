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

import tangelo

from datawake.conf import datawakeconfig as conf
from datawake.util.session.helper import is_in_session


@is_in_session
def get_external_links():
    links = json.dumps(conf.get_external_links())
    tangelo.log(links)
    return links


get_actions = {
    'get': get_external_links
}


@tangelo.restful
def get(action, *args, **kwargs):
    def unknown(**kwargs):
        return tangelo.HTTPStatusCode(400, "invalid service call")

    return get_actions.get(action, unknown)(**kwargs)
