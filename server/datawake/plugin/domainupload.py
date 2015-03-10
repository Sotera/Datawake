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
from datawake.util.db import datawake_mysql as db
from datawake.util.session.helper import is_in_session
from datawake.util.session.helper import has_team
from datawake.util.session.helper import has_domain



def valid_domain_line(line):
    return '\0' not in line


@is_in_session
@has_team
@tangelo.types(team_id=int)
def upload_file(team_id,name, description,features):

    #tangelo.log("Loading new domain: ")
    #tangelo.log(name)
    #tangelo.log(description)
    #tangelo.log(features)

    domain_id = db.add_new_domain(team_id,name, description)

    domain_content_connector = factory.get_entity_data_connector()

    try:
        domain_content_connector.add_new_domain_items(domain_id,features)
    except:
        db.remove_domain(domain_id)
        raise
    finally:
        domain_content_connector.close()

    newdomain = dict(id=domain_id,name=name,description=description)
    #tangelo.log("loaded new domain")
    #tangelo.log(newdomain)
    return json.dumps(newdomain)



@is_in_session
@has_team
@has_domain
@tangelo.types(team_id=int,domain_id=int)
def delete_domain(team_id,domain_id):
    tangelo.log("deleting domain: "+str(domain_id))
    domain_content_connector = factory.get_entity_data_connector()
    domain_content_connector.delete_domain_items(domain_id)
    tangelo.log("delted features")
    db.remove_domain(domain_id)
    tangelo.log("delted meta data")
    return json.dumps(dict(success=True))


get_actions = {}

post_actions = {
    'upload': upload_file,
    'delete': delete_domain
}


@tangelo.restful
def post(action, *args, **kwargs):
    body = tangelo.request_body().read()
    post_data = json.loads(body, strict=False)
    def unknown(*args):
        return tangelo.HTTPStatusCode(400, "invalid service call")

    tangelo.log(post_data)
    return post_actions.get(action, unknown)(**post_data)


@tangelo.restful
def get(action, *args, **kwargs):
    def unknown(*args):
        return tangelo.HTTPStatusCode(400, "invalid service call")

    return get_actions.get(action, unknown)(*args)

