---
layout: post
title: What's New
permalink: /new/
---
In order to give visibility into the use of DataWake for domain definition we plan to post short videos every week or two demonstrating our new capabilities.

<ul>
  {% for post in site.posts %}
    <hr>
    <li>
      <a href="{{ site.baseurl }}{{ post.url }}"><b>{{ post.date | date: '%B %d, %Y' }} - {{ post.title }}</b></a>
      {{ post.content }}
    </li>
  {% endfor %}
</ul>
