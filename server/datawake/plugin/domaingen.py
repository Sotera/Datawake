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
from datawake.util.validate.parameters import required_parameters
from datawake.util.session import helper
import datawake.util.dataconnector.factory as factory



@tangelo.restful
@is_in_session
@required_parameters(['domain','trail'])
def get(domain,trail,stars,newdomain):
    org = helper.get_org().upper()

    if not db.domain_exists(newdomain):
        db.add_new_domain(newdomain,'auto generated domain from trail: '+trail)

    features = set([])
    url_set = set([])
    stars = int(stars)
    # get all stared urls for the trail


    for (url,rank) in db.getRankedUrls(org,trail,domain):
        url_set.add(url)

    if stars < 1:
        urls = db.getBrowsePathUrls(org,trail)
        for url in urls:
           url_set.add(url)


    # get the list of invalid entities for the domain
    markedEntities = set([])
    for (type,value) in db.get_marked_entities_for_domain(org, domain):
        markedEntities.add(value)


    # for each url get all extracted entities
    entity_data_connector = factory.get_entity_data_connector()
    all_entities = entity_data_connector.get_extracted_entities_from_urls(url_set)
    for url,featureDict in all_entities.iteritems():
        for type,values in featureDict.iteritems():
            type = type.replace(',',' ')
            filtered_values = []
            for value in values:
                if value not in markedEntities:
                    value = value.replace(',',' ')
                    features.add(type+"\0"+value)



    # for each url get any manually extracted entities
    for url in url_set:
        for featureObj in db.get_feedback_entities(org, domain, url):
            type = featureObj['type'].replace(',',' ')
            value = featureObj['value'].replace(',',' ')
            features.add(type+"\0"+value)





    entity_data_connector.add_new_domain_items( map(lambda x: newdomain+'\0'+x,features))



