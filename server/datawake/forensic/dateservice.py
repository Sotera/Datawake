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

from datawake.util.db import datawake_mysql
from datawake.util.session import helper

"""

 Returns hour record counts.   Used to display the date time filter bar graph on the forensic view/

"""


@helper.is_in_session
def get_chart(users=u'', trail=u'*', domain=u''):
    org = helper.get_org()
    #tangelo.log('dataservice-get org=' + org + ' users=' + users + ' trail= ' + trail + ' domain=' + domain)
    if trail == u'':
        trail = u'*'
    if len(users) > 0:
        users = users.split(",")
    else:
        users = []

    result = datawake_mysql.getHourlyBrowsePathCounts(org, users, trail, domain=domain)
    return json.dumps(dict(data=result))


post_actions = {
    'chart': get_chart
}


@tangelo.restful
def post(action, *args, **kwargs):
    post_data = json.loads(tangelo.request_body().read())

    def unknown(**kwargs):
        return tangelo.HTTPStatusCode(400, "unknown service call")

    return post_actions.get(action, unknown)(**post_data)
