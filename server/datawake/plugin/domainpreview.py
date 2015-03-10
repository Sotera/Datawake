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
from datawake.util.session.helper import is_in_session
from datawake.util.session.helper import has_team
from datawake.util.session.helper import has_domain
import datawake.util.dataconnector.factory as factory


@tangelo.restful
@is_in_session
@has_team
@has_domain
@tangelo.types(team_id=int,domain_id=int,limit=int)
def get(team_id,domain_id,limit):

    """
    Verify the logged in user has access to the requested team and return N items from the domain
    :param team_id:
    :return: List of domain features
            [{type:.., value:...},..]
    """
    entity_data_connector = factory.get_entity_data_connector()
    results = entity_data_connector.get_domain_items(domain_id,limit)
    return json.dumps(results)
