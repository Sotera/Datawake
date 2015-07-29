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


def set_comments(trail_id, url, comments, crawl_type):
    tangelo.log("%i, %s, %s, %s"%(trail_id,url,comments,crawl_type))
    user = helper.get_user()
    db.setComments(trail_id, url, crawl_type, comments)
    return json.dumps(dict(success=True))


post_actions = {
    'set': set_comments
}


@tangelo.restful
def post(action, *args, **kwargs):
    tangelo.log("Comments")
    post_data = json.loads(tangelo.request_body().read(), strict=False)

    def unknown(**kwargs):
        return tangelo.HTTPStatusCode(404, "unknown service call")

    return post_actions.get(action, unknown)(**post_data)
