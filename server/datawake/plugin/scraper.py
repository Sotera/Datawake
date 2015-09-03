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
import urllib
import datawake.util.db.datawake_mysql as db
import datawake.util.externalTools.deepdive as deepdive
import datawake.util.externalTools.externalTool as tools
import datawake.conf.datawakeconfig as config
from datawake.util.dataconnector import factory
from datawake.util.session.helper import is_in_session
from datawake.util.session.helper import has_team
from datawake.util.session.helper import has_domain
from datawake.util.session import helper
from datawake.util.validate.parameters import required_parameters
from datawake.extractor import master_extractor as extractors
from urlparse import urlparse


"""
    - Record a page visit and extract features
"""



def scrape_page(team_id,domain_id,trail_id,url,content,user_email):

    content = urllib.unquote(content).encode('utf-8')
    url = url.encode('utf-8')

    connector = factory.get_entity_data_connector()

    # blacklist of pages to not extract data from
    blacklist = config.get_extraction_blacklist()
    if urlparse(url).netloc not in blacklist:
        (features,errors) = extractors.extractAll(content)
        for error in errors:
            tangelo.log("FEATURE EXTRACTION ERROR: "+error)

        for type,values in features.iteritems():
            connector.insert_entities(url,type,values)
            if len(values) > 0:
                features_in_domain = connector.get_domain_entity_matches(domain_id,type,values)
                if len(features_in_domain) > 0:
                    tangelo.log("INSERTING DOMAIN ENTITIES")
                    tangelo.log(type)
                    connector.insert_domain_entities(str(domain_id),url, type, features_in_domain)
        # we also don't want to export blacklisted pages.
        tangelo.log("Calling export")
        export_to_services(domain_id, team_id, trail_id, url, content, user_email, features)
    else:
        tangelo.log("Url: %s IN blacklist"%url)

    id = db.addBrowsePathData(team_id,domain_id,trail_id,url, user_email)

    count = db.getUrlCount(team_id,domain_id,trail_id, url)
    result = dict(id=id, count=count)
    return json.dumps(result)

def export_to_services(domain_id, team_id, trail_id, url, content, user_email, entities):
    domain_name = db.get_domain_name(domain_id)
    cdr = tools.build_cdr(url, content, entities, team_id, domain_id, trail_id, domain_name, user_email)
    # deepdive.export(cdr)
    for service in db.get_services(domain_id):
        result = False
        if service['serviceType'] == 'KAFKA':
            result = tools.export_kafka(service, cdr)
        elif service['serviceType'] == 'ES':
            result = tools.export_es(service, cdr, domain_name)
        elif service['serviceType'] == 'REST':
            result = tools.export_rest(service, domain_id, domain_name, cdr)
        if result:
            status = 'success'
        else:
            status = 'error'
        db.service_status(service['recipientId'], service['serviceType'], url, domain_id, team_id, trail_id, status)
        tangelo.log('Submited %s for %s to %s: %s' % (url, domain_name, service['recipientName'], status))


@is_in_session
@has_team
@has_domain
@required_parameters(['team_id','domain_id', 'trail_id', 'html', 'url'])
@tangelo.types(domain_id=int,team_id=int,trail_id=int)
def full_page_scrape(team_id,domain_id, trail_id, html, url):
    user = helper.get_user()
    return scrape_page(team_id,domain_id,trail_id,url,html,user.get_email())


post_actions = {
    'scrape': full_page_scrape,
}


@tangelo.restful
def post(action, *args, **kwargs):
    json_obj = tangelo.request_body().read()
    post_data = json.loads(json_obj, strict=False)

    def unknown(*args):
        return tangelo.HTTPStatusCode(400, "invalid service call")

    return post_actions.get(action, unknown)(**post_data)
