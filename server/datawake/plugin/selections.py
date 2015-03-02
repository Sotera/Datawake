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
import datawake.util.db.datawake_mysql as db
from datawake.util.session.helper import is_in_session
from datawake.util.session.helper import has_team
from datawake.util.session.helper import has_trail
from datawake.util.session import helper
from datawake.util.validate.parameters import required_parameters


"""

 - Save text selections for a page
 - Get Selections for a page

"""


@is_in_session
@has_team
@has_trail
@required_parameters(['selection', 'url'])
@tangelo.types(team_id=int,domain_id=int,trail_id=int)
def save_page_selection(team_id,domain_id,trail_id,selection, url):
    user = helper.get_user()
    row_id = db.addSelection(trail_id,user.get_email(),url, selection)
    return json.dumps(dict(id=row_id))



@is_in_session
@has_team
@has_trail
@required_parameters(['url'])
@tangelo.types(team_id=int,domain_id=int,trail_id=int)
def get_selections(team_id,domain_id,trail_id,url):
    selections = db.getSelections(trail_id, url)
    return json.dumps(selections)


post_actions = {
    'save': save_page_selection,
    'get': get_selections
}


@tangelo.restful
def post(action, *args, **kwargs):
    json_obj = tangelo.request_body().read()
    post_data = json.loads(json_obj, strict=False)

    def unknown(*args):
        return tangelo.HTTPStatusCode(400, "invalid service call")

    return post_actions.get(action, unknown)(**post_data)



