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
@tangelo.types(team_id=int)
def get(team_id):

    """
    Verify the logged in user has access to the requested team and return that teams list of domains.
    :param team_id:
    :return: List of domain objects for the team
            [{'id':domain_id,'name','name':domainname,'description':domaindescription},..]
    """

    user = helper.get_user()

    if not db.hasTeamAccess(user.get_email(),team_id):
        tangelo.content_type()
        tangelo.http_status(401)
        tangelo.log("401 Unauthorized domains/?team_id="+str(team_id)+" user: "+str(user))
        return "401 Unauthorized"
    else:
        results = db.get_domains(team_id)
        return json.dumps(results)