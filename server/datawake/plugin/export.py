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
from datawake.util.db import datawake_mysql as db
from datawake.util.session.helper import is_in_session
from datawake.util.session import helper

@tangelo.restful
@is_in_session
@tangelo.types(trail_id=int)
def get(trail_id):
    user = helper.get_user()
    trail = db.getTrailData(trail_id)
    team = db.get_team(trail['domainId'])
    urls = db.getBrowsePathUrls(trail_id)
    domain = db.get_domain_name(trail['domainId'])
    export_obj = dict(user=user.get_email(), team=team, domain=domain, trail=trail, urls=urls)
    return json.dumps(export_obj, indent=4, sort_keys=True)