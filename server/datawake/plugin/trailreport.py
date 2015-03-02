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

"""
 List / Create Trails

    primarily used on the plugin newTab.

"""

#
# Perform a starts-with search for trails
#
@tangelo.restful
@is_in_session
@required_parameters(['domain','trail'])
def get(domain,trail):
    org = helper.get_org()

    trail_report = {}

    # get all stared urls for the trail
    for (url,rank) in db.getRankedUrls(org,trail,domain):
        trail_report[url] = {'rank':rank, }

    # get the list of invalid entities for the domain
    markedEntities = set([])
    for (type,value) in db.get_marked_entities_for_domain(org, domain):
        markedEntities.add(value)


    # for each url get all extracted entities
    entity_data_connector = factory.get_entity_data_connector()
    all_entities = entity_data_connector.get_extracted_entities_from_urls(trail_report.keys())
    for url,featureDict in all_entities.iteritems():
        for type,values in featureDict.iteritems():
            filtered_values = []
            for value in values:
                if value not in markedEntities:
                    filtered_values.append(value)
            if len(filtered_values) > 0:
                try:
                    if 'auto_features' not in trail_report[url]: trail_report[url]['auto_features'] = {}
                    trail_report[url]['auto_features'][type] = filtered_values
                except:
                    tangelo.log("report generation error. skipping url.")
                    continue


    # for each url get any manually extracted entities
    for url in trail_report.keys():
        for featureObj in db.get_feedback_entities(org, domain, url):
            if 'manual_features' not in trail_report[url]:
                trail_report[url]['manual_features'] = {}
            if featureObj['type'] not in trail_report[url]['manual_features']:
                trail_report[url]['manual_features'][featureObj['type']] = []
            trail_report[url]['manual_features'][featureObj['type']].append(featureObj['value'])


    # for each url get any highlighted text
    for url in trail_report.keys():
        selections = db.getSelections(domain, trail, url, org)
        if len(selections) > 0:
            trail_report[url]['selections'] = selections



    result = {'trail':trail,'urls':trail_report}
    return json.dumps(result,sort_keys=True,indent=4,separators=(',',':'))



