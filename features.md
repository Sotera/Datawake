---
layout: page
title: Features
permalink: /features/
---

# DataWake Domain Dive
Domain Dive takes extracted attributes from a website such as email address, url,
and phone numbers and queries an [Elasticearch](https://www.elastic.co/products/elasticsearch)
index for other pages that contain those attributes.

![Forensic View](../img/preDomainDive.png)
This is our standard Forensic view. Notice the smaller green nodes, these are email
addresses and phone numbers.


![Deep Dive Forensic View](../img/postDomainDive)
This is the Forensic View after performing a Domain Dive. Notice that the smaller
green nodes are now surrounded by small brown nodes. Those are web pages that we
have previously looked at that contain those phone numbers and/or email addresses.


# DataWake Prefetch
Datawake prefetch allows a user to define entities and initiate a crawl of all websites
containing those entities.


First we are going to add an entity.  
![Add Entities](../img/addEntities.png)  


Now we are going to exclude pages relating to baseball.  
![Add Irrelevant Entities](../img/addIrEntities.png)  


Now we can look at pages and how they rank given the defined entities.  
![Explore](../img/viewingPages.png)  
