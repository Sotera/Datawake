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
import cherrypy

from datawake.util.authentication import factory
from datawake.util.db import datawake_mysql
from datawake.util.session import helper as session_helper
from datawake.conf.datawakeconfig import MOCK_FORENSIC_AUTH


@tangelo.restful
@session_helper.is_in_session
def get():
    return json.dumps(dict(user=session_helper.get_user().__dict__, hasSession=True))


@tangelo.restful
def post(token=u''):
    user = session_helper.get_user()

    if user is None:
        auth_helper = factory.get_authentication_object(token,MOCK_FORENSIC_AUTH)
        user = auth_helper.get_user_from_token()
        tangelo.log('session.post verified user: ' + str(user))


        session_helper.set_user(user)
        session_helper.set_token(token)

    return json.dumps(user.__dict__)


@tangelo.restful
def delete():
    tangelo.log('manually expired session')
    return json.dumps(dict(removedSession=session_helper.expire_user()))
