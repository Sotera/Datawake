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


class DataConnector:
    def __init__(self):
        pass


    def open(self):
        raise NotImplementedError("Implement open()")


    def close(self):
        raise NotImplementedError("Implement close()")


    def _check_conn(self):
        raise NotImplementedError("Implement _checkConn()")

    def get_matching_entities_from_url(self, urls):
        raise NotImplementedError("Implement get_matching_entities_from_url() ")

    def get_extracted_domain_entities_for_urls(self, domain_id, urls):
        raise NotImplementedError("Implement get_extracted_domain_entities_for_urls")

    def get_extracted_entities_from_urls(self, urls, type=None):
        raise NotImplementedError("Implement getExtractedEntitiesFromUrls()")


    def get_extracted_domain_entities_from_urls(self, domain_id, urls, type=None):
        raise NotImplementedError("Implement getExtractedDomainEntitiesFromUrls()")


    def get_extracted_entities_with_domain_check(self, urls, types=None, domain='default'):
        raise NotImplementedError("Implement getExtractedEntitiesWithDomainCheck()")


    def get_domain_entity_matches(self, domain_id, type, values):
        raise NotImplementedError("Implement getEntityMatches()")


    def get_domain_items(self, name, limit):
        raise NotImplementedError("Implement get_domain_items()")


    def delete_domain_items(self, domain_name):
        raise NotImplementedError("Implement delete_domain_items()")


    def add_new_domain_items(self, domain_items):
        raise NotImplementedError("Implement add_new_domain_items()")


    def insert_entities(self, url, entity_type, entity_values):
        raise NotImplementedError("Implement insertEntities()")


    def insert_domain_entities(self, domain_id,url, entity_type, entity_values):
        raise NotImplementedError("Implement insertDomainEntities()")

