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

import threading
from Queue import Queue
import json

import tangelo

import datawake.util.dataconnector.factory as factory
from datawake.util.dataconnector.domain_upload_connector import ConnectorUtil
from datawake.util.db import datawake_mysql as db


completed_threads = Queue()


def get_domains(*args):
    domains = db.get_domains()
    return json.dumps(map(lambda x: dict(name=x[0], description=x[1]), domains))


def get_preview(domain):
    domain_content_connector = factory.get_entity_data_connector()
    try:
        data = domain_content_connector.get_domain_items(domain, 10)
        return json.dumps(data)
    finally:
        domain_content_connector.close()


def valid_domain_line(line):
    return '\0' not in line


def finished_database_upload(*args):
    if not completed_threads.empty():
        return json.dumps(completed_threads.get())
    return json.dumps(dict(complete=False))


def upload_file(file_upload, name, description):
    tangelo.log("Loading new domain: "+name)
    domain_content_connector = factory.get_entity_data_connector()
    try:
        if not db.domain_exists(name):
            if file_upload is not None:
                domain_file_lines = file_upload.file.readlines()
                domain_file_lines = map(lambda x: x.strip().replace('\0', ''), domain_file_lines)
                db.add_new_domain(name, description)
                rowkeys = []
                for line in domain_file_lines:
                    i = line.index(',')  # split on the first comma
                    type = line[:i]
                    value = line[i + 1:]
                    if type[0] == '"' and type[len(type) - 1] == '"': type = type[1:-1]
                    if value[0] == '"' and value[len(value) - 1] == '"': value = value[1:-1]
                    rowkeys.append("%s\0%s\0%s" % (name, type, value))
                result = domain_content_connector.add_new_domain_items(rowkeys)
                return json.dumps(dict(success=result))
            return json.dumps(dict(success=False))
        return json.dumps(dict(success=False))
    finally:
        domain_content_connector.close()


def upload_database_threaded(domain_name, connection_string, domain_description, table_name, attribute_column, value_column):
    domain_content_connector = factory.get_entity_data_connector()
    connector = ConnectorUtil.get_database_connector(connection_string, table_name, attribute_column, value_column)
    rows = connector.get_domain_items()
    success = domain_content_connector.add_new_domain_items(map(lambda items: "%s\0%s\0%s" % (domain_name, items[0], items[1]), rows))
    complete_dict = dict(domain=domain_name, description=domain_description, success=success, complete=True)
    completed_threads.put(complete_dict)


def upload_database(domain_name, domain_description):
    if not db.domain_exists(domain_name):
        db.add_new_domain(domain_name, domain_description)
        kwargs = dict(domain_name=domain_name, domain_description=domain_description)
        database_upload_thread = threading.Thread(target=upload_database_threaded, kwargs=kwargs)
        database_upload_thread.daemon = True
        database_upload_thread.start()
        return json.dumps(dict(success=True))
    return json.dumps(dict(success=False))


def delete_domain(domain_name):
    if db.domain_exists(domain_name):
        domain_content_connector = factory.get_entity_data_connector()
        db.remove_domain(domain_name)
        domain_content_connector.delete_domain_items(domain_name)
        return json.dumps(dict(success=True))
    return json.dumps(dict(success=False))


get_actions = {
    'domains': get_domains,
    'poll': finished_database_upload
}

post_actions = {
    'upload': upload_file,
    'preview': get_preview,
    'upload-database': upload_database,
    'delete': delete_domain
}


@tangelo.restful
def post(action, *args, **kwargs):
    def unknown(*args):
        return tangelo.HTTPStatusCode(400, "invalid service call")

    return post_actions.get(action, unknown)(**kwargs)


@tangelo.restful
def get(action, *args, **kwargs):
    def unknown(*args):
        return tangelo.HTTPStatusCode(400, "invalid service call")

    return get_actions.get(action, unknown)(*args)
