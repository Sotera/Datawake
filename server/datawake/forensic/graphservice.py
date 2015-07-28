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
from datawake.util.graph import helper as graph_helper
from datawake.util.session.helper import is_in_session
from datawake.util.session.helper import has_team
from datawake.util.session.helper import has_domain
from datawake.util.session.helper import has_trail
from datawake.util.session import helper


"""

Serves graphs for the datawake forensic viewer.  Graph building is primailry done in datawake.util.graphs

"""

DEBUG = True


#
# Return the graph display options
#
@is_in_session
def listGraphs():
    graphs = dict(graphs=[
                                   'browse path',
                                   'browse path - with adjacent urls',
                                   'browse path - with adjacent urls min degree 2',
                                   'browse path - with adjacent phone #\'s',
                                   'browse path - with adjacent email #\'s',
                                   'browse path - with phone and email #\'s',
                                   'browse path - with bitcoin addresses',
                                   'browse path - with text selections',
                                   'browse path - with adjacent info',])

    return json.dumps(graphs)

#
# return all time stamps from the selected trail,users,org
# returns a dictionary of the form  {'min':0,'max':0,'data':[]}
#
@is_in_session
def getTimeWindow(users, trail=u'*'):
    org = helper.get_org()
    if trail == u'':
        trail = u'*'
    print 'getTimeWindow(', users, ',', trail, ')'
    if len(users) > 0:
        users = users.split(",")
    else:
        users = []
    return json.dumps(db.getTimeWindow(org, users, trail))

@is_in_session
def get_entities(trail_id):
    tangelo.log('Getting entities for trail: %s' % trail_id)
    entities = []

    results = db.get_entities_for_trail(trail_id)
    tangelo.log('Got entities')
    for result in results:
        entity = {}
        split = result['name'].split('->')
        if len(split) > 1:
            entity['type'] = split[0]
            entity['name'] = split[1]
            entity['pages'] = result['pages']
        else:
            entity = result
        entities.append(entity)
    return json.dumps(entities)

@is_in_session
def get_links(domain_name, trail_name):
    tangelo.log('Getting links for %s:%s'%(domain_name,trail_name))
    results = db.get_prefetch_results(domain_name, trail_name)
    return json.dumps(results)

@is_in_session
@has_team
@has_domain
@has_trail
@tangelo.types(trail_id=int,domain_id=int,team_id=int,startdate=int,enddate=int)
def getGraph(team_id,domain_id,trail_id,view, startdate=u'', enddate=u'', users=[]):

    tangelo.log('getGraph( )')
    tangelo.log(users)


    if view == 'browse path':
        graph = graph_helper.getBrowsePathEdges(trail_id,startdate, enddate, users)
        return json.dumps(graph_helper.processEdges(graph['edges'], graph['nodes']))

    if view == 'browse path - with adjacent urls':
        graph = graph_helper.getBrowsePathAndAdjacentWebsiteEdgesWithLimit(domain_id,trail_id, startdate, enddate, 1, users)
        return json.dumps(graph_helper.processEdges(graph['edges'], graph['nodes']))

    if view == 'browse path - with adjacent urls min degree 2':
        graph = graph_helper.getBrowsePathAndAdjacentWebsiteEdgesWithLimit(domain_id,trail_id, startdate, enddate, 2, users)
        return json.dumps(graph_helper.processEdges(graph['edges'], graph['nodes']))

    if view == 'browse path - with adjacent phone #\'s':
        graph = graph_helper.getBrowsePathAndAdjacentPhoneEdgesWithLimit(domain_id,trail_id, startdate, enddate, 1, users)
        return json.dumps(graph_helper.processEdges(graph['edges'], graph['nodes']))

    if view == 'browse path - with adjacent email #\'s':
        graph = graph_helper.getBrowsePathAndAdjacentEmailEdgesWithLimit(domain_id,trail_id, startdate, enddate, 1, users)
        return json.dumps(graph_helper.processEdges(graph['edges'], graph['nodes']))

    if view ==  'browse path - with phone and email #\'s':
        graph = graph_helper.getBrowsePathAndAdjacentEdgesWithLimit(domain_id,trail_id,startdate,enddate,['email','phone'],1,users)
        return json.dumps(graph_helper.processEdges(graph['edges'], graph['nodes']))

    if view == 'browse path - with adjacent info':
        graph = graph_helper.getBrowsePathAndAdjacentInfoEdges(domain_id,trail_id, startdate, enddate,1,users)
        return json.dumps(graph_helper.processEdges(graph['edges'], graph['nodes']))

    if view == 'browse path - with bitcoin addresses':
        graph = graph_helper.getBrowsePathAndAdjacentBitcoinEdgesWithLimit(domain_id,trail_id,startdate,enddate,1,users)
        return json.dumps(graph_helper.processEdges(graph['edges'], graph['nodes']))

    if view == 'OculusForensicRequest':
        rows = graph_helper.getOculusForensicGraph(org,startdate,enddate,userlist,trail,domain)
        return json.dumps(rows)

    if view == 'browse path - with text selections':
        graph = graph_helper.getBrowsePathWithTextSelections(trail_id, startdate, enddate,users)
        return json.dumps(graph_helper.processEdges(graph['edges'], graph['nodes']))

    return json.dumps(dict(nodes=[], links=[]))


get_actions = {
    'list': listGraphs,
}

post_actions = {
    'timewindow': getTimeWindow,
    'get': getGraph,
    'entities': get_entities,
    'links': get_links
}


@tangelo.restful
def post(action, *args, **kwargs):
    post_data = json.loads(tangelo.request_body().read())

    def unknown(**kwargs):
        return tangelo.HTTPStatusCode(400, "invalid service call")

    return post_actions.get(action, unknown)(**post_data)


@tangelo.restful
def get(action, *args, **kwargs):
    def unknown(**kwargs):
        return tangelo.HTTPStatusCode(400, "invalid service call")

    return get_actions.get(action, unknown)(**kwargs)
