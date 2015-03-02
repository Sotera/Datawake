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

from datawake.util.authentication import factory
from datawake.util.db import datawake_mysql
from datawake.util.session import helper
from datawake.conf.datawakeconfig import MOCK_AUTH


def get_org(email):
    org = None

    orgs = datawake_mysql.getOrgLinks(email)
    if len(orgs) == 1:
        org = orgs[0]
    else:
        raise ValueError("Org list length must be 1")
    return org


def get_user(token):
    user = helper.get_user()
    if helper.get_token() != token or user is None:
        user_auth = factory.get_authentication_object(token,MOCK_AUTH)
        user = user_auth.get_user_from_token()

        #tangelo.log('session.post verified user: ' + str(user))
    return user


@tangelo.restful
@helper.is_in_session
def get():
    return json.dumps(dict(user=helper.get_user().__dict__))


@tangelo.restful
def post():
    post_data = json.loads(tangelo.request_body().read(), strict=False)
    token = post_data.get("token")
    #tangelo.log("TOKEN: " + token)
    user = get_user(token)
    helper.set_user(user)
    helper.set_token(token)
    return json.dumps(user.__dict__)


@tangelo.restful
def delete():
    tangelo.log('manually expired session')
    return json.dumps(dict(success=helper.expire_user()))
