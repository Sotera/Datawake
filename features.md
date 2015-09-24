---
layout: page
title: Features
permalink: /features/
---

# DataWake Domain Dive
Domain Dive takes extracted attributes from a website such as email address, url,
and phone numbers and queries an [Elasticsearch](https://www.elastic.co/products/elasticsearch)
index for other pages that contain those attributes.

![Forensic View](../img/preDomainDive.png)
This is our standard Forensic view. Notice the smaller green nodes, these are email
addresses and phone numbers.


![Domain Dive Forensic View](../img/postDomainDive.png)
This is the Forensic View after performing a Domain Dive. Notice that the smaller
green nodes are now surrounded by small brown nodes. Those are web pages that we
have previously looked at that contain those phone numbers and/or email addresses.

# DataWake Manager
The DataWake manager gives users the ability to manage users, domains, and
settings. Additionally, the application can be configured to export all page
content and extracted information to RESTFul service, Elasticsearch, or Kafka.

![DataWake-Manager](../img/manager.png)

# DataWake Prefetch
Datawake prefetch allows a user to define entities and initiate a crawl of all websites
containing those entities.

More information on DataWake Prefetch can be found on our [Gihub Page](http://sotera.github.io/datawake-prefetch)
