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

import urllib
import json

import tangelo

import datawake.util.db.datawake_mysql as db
from datawake.util.session.helper import is_in_session
from datawake.util.session.helper import has_team
from datawake.util.session.helper import has_domain
from datawake.util.session.helper import has_trail
from datawake.util.session import helper
from datawake.util.validate.parameters import required_parameters


"""

  User ranks a url (within the context of a trail)

"""


#
# Get the ranking for a url
# specific to a user and trail
#
@is_in_session
@has_team
@has_trail
@required_parameters([ 'url'])
@tangelo.types(team_id=int,domain_id=int,trail_id=int)
def get_rank(team_id,domain_id,trail_id, url):
    user = helper.get_user()
    url = url.encode('utf-8')
    url = urllib.unquote(url)
    rank = db.getUrlRank(trail_id,user.get_email(),url)
    response = dict(rank=rank)
    return json.dumps(response)


#
# Set the ranking for a url
# specifc to a user and trail
@is_in_session
@has_team
@has_trail
@required_parameters(['url','rank'])
@tangelo.types(team_id=int,domain_id=int,trail_id=int,rank=int)
def set_rank(team_id,domain_id,trail_id,url,rank):
    user = helper.get_user()
    db.rankUrl(team_id,domain_id,trail_id,user.get_email(),url,rank)
    return json.dumps(dict(success=True))


post_actions = {
    'get': get_rank,
    'set': set_rank
}


@tangelo.restful
def post(action, *args, **kwargs):
    post_data = json.loads(tangelo.request_body().read(), strict=False)

    def unknown(**kwargs):
        return tangelo.HTTPStatusCode(404, "unknown service call")

    return post_actions.get(action, unknown)(**post_data)