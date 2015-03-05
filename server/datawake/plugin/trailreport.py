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
from datawake.util.session.helper import has_team
from datawake.util.session.helper import has_trail
import datawake.util.dataconnector.factory as factory

"""

Provide a JSON document that details all data in a trail.

"""


#
# Perform a starts-with search for trails
#
@tangelo.restful
@is_in_session
@has_team
@has_trail
@tangelo.types(stars=int)
def get(team_id,domain_id,trail_id,stars,extracted_features):

    """

    :param team_id:  id of the team
    :param domain_id: id of domain
    :param trail_id: id of the trail
    :param stars: minimum avg star ranking to allow in report
    :param extracted_features: y or n (include auto extracted features in report)
    :return:
        {
            trail: {id:..,name:...,description:.., url-count}
            urls: [
                {
                    url: ..,
                    url-visit-count: ..
                    rank: {min: ?, max: ?, avg: ?, count: ?}, # rounded to nearest tenth
                    auto_features: { type: [value,..],..},
                    manual_feature: { type: [value,..],..},
                    selections: {ts: "2015-02-25 16:24:41", selection: "selected text"}
                },..
            ]
        }

    """


    trailData = db.getTrailData(trail_id)
    trail_report = {}


    # get ranked urls
    for rankObject in db.getRankedUrls(trail_id):
        if  rankObject['avg'] >= stars:
            url = rankObject['url']
            del rankObject['url']
            trail_report[url] = {'url': url, 'rank':rankObject}

    # get url hit counts and un ranked urls
    for urlObj in db.getBrowsePathUrls(trail_id):
        url = urlObj['url']
        if url in trail_report or stars < 1:
            if url not in trail_report:
                trail_report[url] = {'url': url, 'rank':{'min':0,'max':0,'avg':0,'count':0} }
            trail_report[url]['url-visit-count'] = urlObj['count']



    trailData['url-count'] = len(trail_report.keys())

    # get the list of invalid entities for the domain
    if extracted_features != 'n':
        markedEntities = set([])
        for featureObj in db.get_marked_features(trail_id):
            key = featureObj['type']+':'+featureObj['value']
            markedEntities.add(key)


        # for each url get all extracted entities
        entity_data_connector = factory.get_entity_data_connector()
        all_entities = entity_data_connector.get_extracted_entities_from_urls(trail_report.keys())
        for url,featureDict in all_entities.iteritems():
            for type,values in featureDict.iteritems():
                filtered_values = []
                for value in values:
                    key = type+':'+value
                    if key not in markedEntities:
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
        for featureObj in db.get_manual_features(trail_id,url):
            if 'manual_features' not in trail_report[url]:
                trail_report[url]['manual_features'] = {}
            if featureObj['type'] not in trail_report[url]['manual_features']:
                trail_report[url]['manual_features'][featureObj['type']] = []
            trail_report[url]['manual_features'][featureObj['type']].append(featureObj['value'])


    # for each url get any highlighted text
    for url in trail_report.keys():
        selections = db.getSelections(trail_id, url)

        # lets keep user names out of reports for now
        if len(selections) > 0:
            for sel in selections:
                del sel['userEmail']
            trail_report[url]['selections'] = selections


    result = {'trail': trailData,'urls':trail_report.values()}
    return json.dumps(result,sort_keys=True,indent=4,separators=(',',':'))



