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
import tangelo
import datawake.util.dataconnector.factory as factory
from datawake.util.db import datawake_mysql


"""

Provides all the functionality around building graphs for display on the datawake
forensic view.

"""

entityDataConnector = factory.get_entity_data_connector()

def getBrowsePathEdges(trail_id,startdate,enddate,userlist=[]):
    tangelo.log('getBrowsePathEdges(%s,%s,%s)'%(startdate, enddate, userlist))

    rows = datawake_mysql.getVisitedUrlsInTrailForTimeRange(trail_id,startdate,enddate,userlist)

    edges = []
    nodes = {}
    edge_buffer = []
    for row in rows:
        tangelo.log(row)
        ts = row['ts']
        url = row['url']
        userEmail = row['userEmail']
        hits = row['hits']

        if url not in nodes:
            nodes[url] = {'id':url,
                              'type':'browse path',
                              'size':10,
                              'timestamps':[],
                              'hits':0,
                              'userNames':[]
            }
        nodes[url]['timestamps'].append(ts)
        nodes[url]['hits'] = hits
        nodes[url]['userNames'].append(userEmail)

        edge_buffer.append(url)
        if len(edge_buffer) == 2:
            if (edge_buffer[0] != edge_buffer[1]):
                if 'chrome://newtab/' not in edge_buffer[1]:
                    users1 = nodes[edge_buffer[0]]['userNames'][-1]
                    users2 = nodes[edge_buffer[1]]['userNames'][-1]
                    if users1 == users2:
                        edges.append((edge_buffer[0],edge_buffer[1]))
            edge_buffer = [edge_buffer[1]]


    # set group name from each node
    for key,value in nodes.iteritems():
        domain = 'n/a'
        if key is None:
            continue
        if '//' in key:  domain =  key.split('/')[2]
        value['groupName'] = domain

    return {'nodes':nodes,'edges':edges}


def getBrowsePathAndAdjacentEdgesWithLimit(domain_id,trail_id,startdate,enddate,adjTypes,limit,userlist=[]):
    entityDataConnector.close()

    browsePathGraph = getBrowsePathEdges(trail_id,startdate,enddate,userlist)
    urls = browsePathGraph['nodes'].keys()

    results = entityDataConnector.get_extracted_entities_with_domain_check(domain_id, urls, adjTypes)

    nodes = browsePathGraph['nodes']
    edges = browsePathGraph['edges']


    # pivot on entity->urls
    entity_to_urls = {}
    for url,entityObjDict in results.iteritems():
        for type,valueDict in entityObjDict.iteritems():
            for value,in_domain in valueDict.iteritems():
                key = (type,value)
                if key not in entity_to_urls:
                    entity_to_urls[key] = {'indomain':'n','urls':set([])}
                entity_to_urls[key]['urls'].add(url)
                if (in_domain == 'y'): entity_to_urls[key]['indomain'] = 'y'

    # add entities with at least <limit> urls
    for key,value in entity_to_urls.iteritems():
        if len(value['urls']) >= limit:
            (type,name) = key
            #name = name.encode()
            group = ''
            if type == 'website':
                if '//' in name:  group =  name.split('/')[2]
            elif type == 'phone':
                group = 'length= '+str( len(name))
            elif type == 'email' and '@' in name:
                group = name.split('@')[1]
            elif type == 'info':
                group = name.split('->')[0]
            node = {'id':name,
                    'type':type,
                    'size':5,
                    'groupName':group
            }
            if name not in nodes:
              nodes[name]= node
            for url in value['urls']:
                edges.append((url,name))

    entityDataConnector.close()
    return {'nodes':nodes,'edges':edges}

def getBrowsePathAndAdjacentWebsiteEdgesWithLimit(domain_id,trail_id,startdate,enddate,limit,userlist=[]):
    return getBrowsePathAndAdjacentEdgesWithLimit(domain_id,trail_id,startdate,enddate,['website'],limit,userlist)

def getBrowsePathAndAdjacentPhoneEdgesWithLimit(domain_id,trail_id,startdate,enddate,limit,userlist=[]):
    return getBrowsePathAndAdjacentEdgesWithLimit(domain_id,trail_id,startdate,enddate,['phone'],limit,userlist)

def getBrowsePathAndAdjacentEmailEdgesWithLimit(domain_id,trail_id,startdate,enddate,limit,userlist=[]):
    return getBrowsePathAndAdjacentEdgesWithLimit(domain_id,trail_id,startdate,enddate,['email'],limit,userlist)

def getBrowsePathAndAdjacentInfoEdges(domain_id,trail_id,startdate,enddate,limit,userlist=[]):
    return getBrowsePathAndAdjacentEdgesWithLimit(domain_id,trail_id,startdate,enddate,['PERSON','ORGANIZATION','MISC'],limit,userlist)

def getBrowsePathAndAdjacentBitcoinEdgesWithLimit(domain_id,trail_id,startdate,enddate,limit,userlist=[]):
    return getBrowsePathAndAdjacentEdgesWithLimit(domain_id,trail_id,startdate,enddate,['bitcoin'],limit,userlist)


def getBrowsePathWithTextSelections(trail_id,startdate,enddate,userlist=[]):
    # first get the browse path
    graph = getBrowsePathEdges(trail_id,startdate,enddate,userlist)
    nodes = graph['nodes']
    edges = graph['edges']

    newnodes = {}
    try:
        # for each node in the browse path pull any related notes:
        for key,node in nodes.iteritems():
            selections = datawake_mysql.getSelections(trail_id, key)
            for selection in selections:
                ts = selection['ts']
                user = selection['userEmail']
                text = selection['selection']
                id = 'selection_'+str(user)+'_'+str(ts)
                node = {
                    'id':id,
                    'type':'selection',
                    'size':5,
                    'groupName':user,
                    'timestamps':[ts],
                    'userNames':[user],
                    'data':text
                }
                newnodes[id] = node
                edges.append((key,id))

        nodes.update(newnodes)

        return {'nodes':nodes,'edges':edges}
    except:
        raise

#
# Process a list of edges and nodes into a json graph
#
def processEdges(rawEdges,nodeDict={}):
    nodes = []
    edges = []
    curr_node = 0
    node_map  = {}
    groups = {}
    curr_group = 0


    #process add nodes
    for key,value in nodeDict.iteritems():
        if key not in node_map:
            if key is None:
                continue
            groupName = value['groupName']
            if groupName not in groups:
                groups[groupName] = curr_group
                curr_group +=1
            group = groups[groupName]

        value['group'] = group
        value['index'] = curr_node
        value['community'] = 'n/a'
        value['name'] = value['type']+" "+value['groupName']+":"+key

        nodes.append(value)
        node_map[key] = curr_node
        curr_node +=1

    # process edges and add extra nodes if found
    for edge in rawEdges:
        value = 1
        if len(edge) > 2: value = edge[2]
        edges.append({"source":node_map[edge[0]],'target':node_map[edge[1]],'value':value})

    graph = {'nodes':nodes, 'links':edges}

    return graph
