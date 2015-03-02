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

import sys
import argparse
import os.path

from datawake.util.db import datawake_mysql


"""
Command line utility for adding and removing domain entities

usage python orgLoader.py  enityfile.csv

"""

def loadEntities(file,domainName):

    domainName = domainName.replace('\0','')

    if not os.path.isfile(file):
        print 'file not found ',file
        sys.exit(1)

    cnx = datawake_mysql.get_cnx()
    cursor = cnx.cursor()
    sql = "INSERT INTO datawake_domain_entities (rowkey) VALUES (%s)"
    fobj = open(file,'r')

    i = 0
    for row in fobj:
        try:
          j = row.index(',')
          type = row[:j].replace('\0','')
          value = row[j+1:].replace('\0','')
        except:
            print 'error parsing row: ',row
            continue
        urn = domainName+ '\0' + type + '\0' + value
        i = i + 1

        cursor.execute(sql,[urn])
        if i % 1000 == 0:
            cnx.commit()

    cnx.commit()
    fobj.close()

    #sql = "CREATE INDEX urn_idx ON datawake_domain_entities (rowkey(300))"
    #cursor.execute(sql)
    #cnx.commit()

    cursor.close()
    cnx.close()





if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Add domain entities')
    parser.add_argument('entityFile',help='line delimited entity file.')
    parser.add_argument('domainName',help='name for this domain.')
    args = parser.parse_args()
    loadEntities(args.entityFile,args.domainName)
