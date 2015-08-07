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
import igraph
import tangelo
import time
import datawake.util.dataconnector.factory as factory
import tldextract
from datawake.util.db import datawake_mysql
from urlparse import urlparse


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
        if '//' in key:  domain =  key.split('/')[2]
        value['groupName'] = domain

    # TODO add in url ranks
    #if len(userlist) == 1 and trail != '*':
    #    nodes = addUrlRankstoNodes(org,nodes,userlist[0],trail,domain=domain)

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


def getOculusForensicGraph(org,startdate,enddate,userlist=[],trail='*',domain=''):
    startMillis = int(round(time.time() * 1000))
    entityDataConnector.close()
    org = org.upper()

    command = """
      SELECT id,unix_timestamp(ts) as ts,url
      FROM memex_sotera.datawake_data
      WHERE org=%s AND domain=%s
      """
    params = [org,domain]


    # add the user list filter if given
    if (len(userlist) > 0):
        command = command +" AND "
        newparams = ['%s' for i in range(len(userlist))]
        newparams = ','.join(newparams)
        command = command + "  userId in ("+params+") "
        params.extend(newparams)

    # add the trail filter
    if trail != '*':
        command = command +" AND trail = %s"
        params.append(trail)




    # add the time filter to the query
    if (startdate == '' and enddate == ''):
        pass
    elif (startdate != '' and enddate == ''):
        command = command +" AND unix_timestamp(ts) >= %s "
        params.append(startdate)
    elif (startdate == '' and enddate != ''):
        command = command + "  AND unix_timestamp(ts) <= %s "
        params.append(enddate)
    else:
        command = command + " AND unix_timestamp(ts) >= %s and unix_timestamp(ts) <= %s "
        params.append(startdate)
        params.append(enddate)


    command = command + " GROUP BY url ORDER BY ts asc "

    db_rows = datawake_mysql.dbGetRows(command,params)
    urls = map(lambda x: x[2],db_rows)
    extracted_features = entityDataConnector.get_extracted_entities_from_urls(urls)

    browsePath = {}
    adj_urls = set([])
    entities = []
    for row in db_rows:
        (id,ts,url) = row
        #tangelo.log("URL: "+url)
        if url not in extracted_features:
            #tangelo.log("skipping url: "+url)
            continue
        extracted_features_for_url = extracted_features[url]
        for entity_type,entity_values in extracted_features_for_url.iteritems():
            if entity_type == "info":
                continue
            #tangelo.log("\tENTITY TYPE: "+entity_type)
            for entity_value in entity_values:
                #tangelo.log("\t\tENTITY VALUE: "+entity_value)
                if trail is None or trail.strip() == '': trail = "default"

                if id not in browsePath:
                    ext = tldextract.extract(url)
                    browsePath[id] = {'id':id,
                              'url':url,
                              'timestamp':ts,
                              'subdomain':ext.subdomain,
                              'domain':ext.domain,
                              'suffix':ext.suffix
                    }

                entity = {
                    'id':id,
                    'type':entity_type,
                    'value':entity_value
                }
                bAdd = True;
                if (entity_type=='email'):
                    emailPieces = entity_value.split('@')
                    entity['user_name'] = emailPieces[0]
                    emailURL = 'mailto://'+emailPieces[1]
                    emailExt = tldextract.extract(emailURL)
                    entity['domain'] = emailExt.domain
                    entity['subdomain'] = emailExt.subdomain
                elif (entity_type=='phone'):
                    areaCode = ''
                    if (len(entity_value) == 10):
                        areaCode = entity_value[1:4]

                    if (areaCode != ''):
                        entity['area_code'] = areaCode
                else:
                    adj_urls.add(entity_value)
                    webExt = tldextract.extract(entity_value)
                    entity['subdomain']=webExt.subdomain
                    entity['domain']=webExt.domain
                    entity['suffix']=webExt.suffix

                if (bAdd):
                    entities.append(entity)

    # Get all the lookahead features
    if (len(adj_urls) > 0):
        lookaheadFeatures = entityDataConnector.get_extracted_entities_from_urls(adj_urls)

        # add place holders for urls with no extracted data
        for adj_url in adj_urls:
            if adj_url not in lookaheadFeatures:
                lookaheadFeatures[adj_url] = {}

        domainLookaheadFeatures = entityDataConnector.get_extracted_domain_entities_from_urls(domain,adj_urls)
    else:
        lookaheadFeatures = []
        domainLookaheadFeatures = []


    entityDataConnector.close()
    endMillis = int(round(time.time() * 1000))
    # tangelo.log('Processing time = ' + str((endMillis-startMillis)/1000) + 's');
    return {
        'browsePath':browsePath,
        'entities':entities,
        'lookaheadFeatures':lookaheadFeatures,
        'domainLookaheadFeatures':domainLookaheadFeatures
    }




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

        #if len(userlist) == 1:
        #    nodes = addUrlRankstoNodes(org,nodes,userlist[0],trail,domain=domain)


        return {'nodes':nodes,'edges':edges}
    except:
        raise

#
# add the url ranking to a set of nodes, and update the node size
#
def addUrlRankstoNodes(org,nodes,user,trail,domain=''):
    ranks = datawake_mysql.getUserUrlRanks(org,user,trail,domain=domain)
    for key,node in nodes.iteritems():
        if key in ranks:
            rank = ranks[key]
            node['rank'] = rank
            node['size'] = node['size'] + (2*min(10,rank))
            print 'set rank ',rank,' for key: ',key
        else:
            print 'key not found: ',key
    return nodes


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
            #type = value['type']
            #if ':' in key:
            #    type = key[:key.index(':')]
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

    # adding in community detection
    if len(edges) > 0:
        gedges = []
        for e in edges:
            gedges.append((e['source'],e['target']))

        g = igraph.Graph(len(nodes)+1)
        g.add_edges(gedges)
        g.vs['node'] = nodes
        g = g.as_undirected(mode='collapse')
        clustering = g.community_multilevel()

        idx = 0
        for subgraph in clustering.subgraphs():
            for node in subgraph.vs['node']:
                node['community'] = idx
            idx += 1

    return graph





def getBrowsePathWithLookAhead(org,startdate,enddate,userlist=[],trail='*',domain=''):
    entityDataConnector.close()
    #t1 = time.time()
    browsePathGraph = getBrowsePathEdges(org,startdate,enddate,userlist,trail,domain)
    #t2 = time.time()
    #tangelo.log("GOT BROWSE PATH IN "+str(t2-t1))
    nodes = browsePathGraph['nodes']
    edges = browsePathGraph['edges']
    urls = browsePathGraph['nodes'].keys()

    # for every url in the browse path get all extracted entities and collect all adjacent urls in a set + url-> link map
    #t1 = time.time()
    visitedEntities = entityDataConnector.get_extracted_entities_from_urls(urls)
    #t2 = time.time()
    #tangelo.log("GOT ALL VISITED ENTITIES IN "+str(t2-t1))

    entity_set = set([])
    adj_urls = set([])
    link_map = {}
    for url,resultObj in visitedEntities.iteritems():
        for type,values in resultObj.iteritems():
            for value in values:
                entity_set.add(type+":"+value)
                if 'website' == type:
                    if value not in link_map:
                        link_map[value] = set([url])
                    else:
                        link_map[value].add(url)
                    adj_urls.add(value)


    del visitedEntities

    #t1 = time.time()
    lookaheadFeatures = entityDataConnector.get_extracted_entities_from_urls(adj_urls)
    #t2 = time.time()
    #tangelo.log("GOT ALL LOOKAHEAD ENTITIES IN "+str(t2-t1))

# add place holders for urls with no extracted data
    for adj_url in adj_urls:
        if adj_url not in lookaheadFeatures:
            lookaheadFeatures[adj_url] = {}

    #t1 = time.time()
    domainLookaheadFeatures = entityDataConnector.get_extracted_domain_entities_from_urls(domain,adj_urls)
    #t2 = time.time()
    #tangelo.log("GOT DOMAIN LOOKAHEAD ENTITIES IN "+str(t2-t1))

    #t1 = time.time()

    for link,resultObj in lookaheadFeatures.iteritems():
        webdomain = 'n/a'
        if '//' in link:  webdomain =  link.split('/')[2]

        all_matches = []
        for type,values in resultObj.iteritems():
            for value in values:
                if type+':'+value in entity_set:
                    all_matches.append(type+':'+value)

        domain_matches = []
        if link in domainLookaheadFeatures:
            for type,values in domainLookaheadFeatures[link].iteritems():
                for value in values:
                    domain_matches.append(type+':'+value)


        node = {'id':link,
                'type':'lookahead',
                'size':5,
                'groupName':webdomain,
                'entity_matches': all_matches,
                'domain_entity_matches': domain_matches,
                }

        if link not in nodes:
            if link in link_map:
                nodes[link] = node
                for url in link_map[link]:
                    edges.append((url,link))
            else:
                tangelo.log("getBrowsePathWithLookAhead:: KeyError. ignoring link: "+link)

    #t2 = time.time()
    #tangelo.log("PROCESSED GRAPH IN "+str(t2-t1))
    entityDataConnector.close()
    return {'nodes':nodes,'edges':edges}
