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

import datawake.util.dataconnector.factory as factory
from datawake.util.validate.parameters import required_parameters
from datawake.util.session.helper import is_in_session


"""

  Get lookahead data for a give URL

"""


@is_in_session
@required_parameters(['url', 'srcurl', 'domain'])
def get_lookahead(url, srcurl, domain):
    entity_data_connector = None
    try:
        entity_data_connector = factory.get_entity_data_connector()
        # get the features from the lookahead url that are also on the src url
        matches = entity_data_connector.get_matching_entities_from_url([url, srcurl])
        domain_matches = entity_data_connector.get_extracted_domain_entities_for_urls(domain, [url])
        result = dict(url=url, matches=matches, domain_search_matches=domain_matches)
        return json.dumps(result)
    finally:
        if entity_data_connector is not None:
            entity_data_connector.close()


post_actions = {
    'matches': get_lookahead
}


@tangelo.restful
def post(action, *args, **kwargs):
    post_data = json.loads(tangelo.request_body().read(), strict=False)

    def unknown(**kwargs):
        return tangelo.HTTPStatusCode(400, "unknown service call")

    return post_actions.get(action, unknown)(**post_data)
