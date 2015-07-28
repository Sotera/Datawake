/*

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

 */


/*jslint browser: true, unparam: true */

/*globals tangelo, $, d3, SWG */

var highlight_options = [];
var communities = {};
var color = d3.scale.category20();
var min_timestamp;
var max_timestamp;
var min_hits;
var max_hits;
var selected_data;
var USERS = {
  all: {},
  max: 1
};
var ALL_TIMESTAMPS = [];
var selected_data;
var repulsion_scale = d3.scale.linear().domain([0, 50]).range([1000, 30]);

/*
 Calculate duration in printable format
 */
function formatDuartion(start, end) {
  var duration = end - start;
  var days = parseInt(duration / (3600 * 24));
  duration = duration - (days * 3600 * 24);
  var hours = parseInt(duration / 3600);
  duration = duration - (hours * 3600);
  var minutes = parseInt(duration / 60);
  return days + " days " + hours + " hours " + minutes + " minutes";
}

/*
 Called whenever a graph is selected to load and draw
 the new graph.
 */
function change_graph(graph) {

  // $("#dialog").dialog().dialog("close");
  console.log("GRAPH")
  console.log(graph)

  communities = {};
  var nodes = graph.nodes.slice();
  var repulsion = 30;
  if (nodes.length < 50) {
    repulsion = parseInt(repulsion_scale(nodes.length));
  }
  console.log("default repulsion = " + repulsion);
  // $("#forceslider").slider("value", repulsion);


  min_timestamp = -1;
  max_timestamp = -1;
  min_hits = -1;
  max_hits = -1;

  USERS.all = {};
  USERS.max = 1;
  for (var i in nodes) {
    var node = nodes[i];

    for (var j in node.userNames) {
      var username = node.userNames[j];
      if (!(username in USERS.all)) {
        USERS.all[username] = USERS.max;
        USERS.max = USERS.max + 1
      }
    }

    if (node.timestamps) {
      var ts = node.timestamps[node.timestamps.length - 1];
      if (min_timestamp == -1 || ts < min_timestamp)
        min_timestamp = ts;
      if (ts > max_timestamp)
        max_timestamp = ts;
    }
    if (node.hits) {
      if (node.hits > max_hits)
        max_hits = node.hits;
      if (min_hits == -1 || node.hits < min_hits)
        min_hits = node.hits;
    }
    if (node.community) {
      communities[node.community] = node.community;
    }
  }

  SWG.drawGraph('node_graph', graph);
  SWG.show_base_legend();

  SWG.viz.selectAll(".node").on('click', function(d) {
    console.log("selected: " + JSON.stringify(d));
    selected_data = d;
  });

  SWG.viz.selectAll(".node").on('click', function(d) {
    showLinkDialog(d);
    SWG.viz.selectAll(".node").style("stroke-width", function(d) {
      return 0;
    });
    d3.select(this).style("stroke", function(d) {
      return 'yellow';
    }).style("stroke-width", function(d) {
      return 4;
    });
  });

  SWG.viz.selectAll(".link")
    .attr("class", function(d) {
      if (d[0].name && d[2].name) {
        var type1 = d[0].name.substring(0, d[0].name.indexOf(":"));
        var type2 = d[2].name.substring(0, d[2].name.indexOf(":"));
        if (type1.indexOf('browse path') == 0 && type2.indexOf('browse path') == 0) {
          return "link boldlink";
        }
      }
      return "link";
    })
    .attr("marker-end", function(d) {
      if (d[0].name && d[2].name) {
        var type1 = d[0].name.substring(0, d[0].name.indexOf(":"));
        var type2 = d[2].name.substring(0, d[2].name.indexOf(":"));
        if (type1.indexOf('browse path') == 0 && type2.indexOf('browse path') == 0) {
          return "url(#arrowhead)";
        }
      }
      return "";
    });
}


/*
 Override the SWG.node_text_func to change
 the node text that is displayed.

 Default behavior is to display the node name the same as here.
 We override here for example purposes only
 */
SWG.node_text_func = function(d) {
  //return d.name;

  if (d.type == 'selection') {
    return d.type + ' ' + d.data
  } else if (d.type == 'domain search') {
    return 'domain search-' + d.jindex + ': ' + d.search_term
  }
  else if (d.type != 'browse path' && d.type != 'website') {
    return d.type + ' ' + d.id
  } else {
    return d.type + ' ' + d.groupName
  }
};


/*
 When the highlight selection changes,
 re-color the graph and show
 a dialog box listing the highlighted terms
 */
function change_highlight(colorOption) {
  $("#dialog").dialog().dialog("close");

  // Default coloring
  if (!colorOption || colorOption.value == "none") {
    SWG.defaultColors();

  } else if (colorOption.value == "community") { // color by community
    SWG.viz.selectAll("svg circle")
      .attr("r", function(d) {
        if (d.size) return d.size;
        else return 5;
      })
      .style("fill", function(d) {
        group = "grey";
        if (d.community) group = color(communities[d.community]);
        return group;
      });
    SWG.show_legend(Object.keys(communities), function(d) {
      return color(communities[d])
    })
  } else if (colorOption.value == 'hits') { // color by hits
    console.log("color by hits min: " + min_hits + " max: " + max_hits);
    SWG.clear_legend();
    var color_delta = parseInt(max_hits / 3);
    var gradient_color = d3.scale.linear()
      .domain([1, color_delta * 1, color_delta * 2, color_delta * 3])
      .range(["green", "yellow", "orange", "red"]);

    d3.selectAll("svg circle")
      .style("fill", function(d) {
        group = "grey";
        if (d.hits) group = gradient_color(d.hits);
        return group;
      });

    show_hits_legend();
  } else if (colorOption.value == 'timestamp') { // color by timestamps
    SWG.clear_legend();
    var gradient_color = d3.scale.linear()
      .domain([min_timestamp, max_timestamp])
      .range(["#E5FAE6", "#00CE09"]);

    d3.selectAll("svg circle")
      .style("fill", function(d) {
        group = gradient_color(0);
        if (d.timestamps && d.timestamps.length > 0)
          group = gradient_color(d.timestamps[d.timestamps.length - 1]);
        return group;
      });
    show_timestamp_legend();
  } else if (colorOption.value == 'user') { // color by user
    SWG.clear_legend();

    d3.selectAll("svg circle")
      .style("fill", function(d) {
        group = 0;
        if (d.userNames && d.userNames.length > 0)
          group = USERS.all[d.userNames[0]];
        return color(group);
      })
    var users = USERS.all;
    SWG.show_legend(Object.keys(USERS.all), function(d) {
      return color(users[d]);
    });

  }

  // TODO restore coloring by type
  //else { // highlight node type
  //    SWG.hightlightType(selected_term);
  //    SWG.showTypeDialog(selected_term);
  // }

}


function refreshForensicView() {
  SWG.clear_legend();
  d3.select('#node_graph').selectAll("svg").remove();
}


/*
 Load the UI controls
 */
window.onload = function() {
  // Create control panel.
  $("#control-panel").controlPanel();

  // Enable the popover help items.
  //
  // First create a config object with the common options present.
  var popover_cfg;
  popover_cfg = {
    html: true,
    container: "body",
    placement: "top",
    trigger: "hover",
    title: null,
    content: null,
    delay: {
      show: 100,
      hide: 100
    }
  };
  $.get("/datawake/version/number", function(response) {
    var resp = JSON.parse(response);
    $("#forensic_version").html(resp.version);
  });

  // Dataset pulldown help.
  popover_cfg.content = "<b>Select a Graph:</b><br><br>" +
    "Choose a graph form the list.";
  $("#search_help").popover(popover_cfg);

  popover_cfg.content = "<b>Select a Graph:</b><br><br>" +
    "Filter the graph by selecting a combination of:<Br>" +
    "1. Zero or one Trails<br>" +
    "2. Zero or more users<br>" +
    "3. A time range<br><br>"
  $("#filter_help").popover(popover_cfg);


};

function show_timestamp_legend() {
  var min = parseInt(min_timestamp);
  var max = parseInt(max_timestamp);
  if (min == -1) return;

  var oneday = 60 * 60 * 24;
  var days = (max - min) / oneday;
  var timestamp_dict = {};
  var gradient_color = d3.scale.linear()
    .domain([min_timestamp, max_timestamp])
    .range(["#E5FAE6", "#00CE09"]);
  var delta = oneday;
  if (days > 20) delta = 7 * oneday; // use weeks if > 20 days
  if (days > 7 * 20) delta = oneday * 30; // use ~months if > than 20 weeks
  if (days > 365 * 2) delta = ondeay * 365; // user years if > 24 months

  var curr = min;
  while (curr <= max) {
    timestamp_dict[new Date(curr * 1000)] = gradient_color(curr);
    curr = curr + delta;
  }
  SWG.show_legend(Object.keys(timestamp_dict), function(d) {
    return timestamp_dict[d];
  })

}

function show_hits_legend() {
  var min = parseInt(min_hits);
  var max = parseInt(max_hits);
  if (min == -1)
    return;

  var hit_dict = {};
  var color_delta = parseInt(max / 3);
  var gradient_color = d3.scale.linear()
    .domain([min, color_delta * 1, color_delta * 2, max])
    .range(["green", "yellow", "orange", "red"]);

  var delta = parseInt((max - min) / 20);
  if (delta < 1) delta = 1;
  var curr = min;
  while (curr <= max) {
    hit_dict[curr] = gradient_color(curr);
    curr = curr + delta;
  }
  SWG.show_legend(Object.keys(hit_dict), function(d) {
    return hit_dict[d];
  });
}


/*
 Display all vertex details in a popup dialog
 */
function showLinkDialog(data) {

  // close previous dialog and remove all content
  $("#link-dialog").dialog().dialog("close");
  d3.select("#link-dialog").selectAll("div").remove();
  $("#link-dialog").dialog("destroy");


  var id = data.id;
  var type = data.type;
  var search_term = data.search_term;
  var nid = data.nid;
  var st = data.id;
  if (type == 'selection') {
    st = data.data;
  }
  console.log(data);



  var mainDiv = d3.select("#link-dialog").append("div");

  // head heading
  mainDiv.append("h4").text(id);
  // provide a link if the id starts with http
  if (id.substring(0, 4) == "http") {
    mainDiv.append("a")
      .style("font-color", "#428bca")
      .style("text-decoration", "underline")
      .attr("href", id)
      .attr("target", "blank")
      .text("open in new tab");
  }
  mainDiv.append("hr");

  // display the node type
  var p1 = mainDiv.append("p");
  p1.text("Node Type: ");
  p1.append("span").text(type);
  mainDiv.append("hr");

  if (search_term != undefined) {
    var p1 = mainDiv.append("p");
    p1.text("Searched ");
    p1.append("span").text(data.search_url + data.jindex + ' for "' + search_term + '"');
    mainDiv.append("hr");
  }


  // display links to other tools
  if (type != "selection") {
    mainDiv.append("h4").text("Memex Tools");
    getExternalLinks(mainDiv, type, id)
    mainDiv.append("hr");

    // list the visit history
    if (data.userNames && data.userNames.length > 0) {
      mainDiv.append("h4").text("Visit History");
      mainDiv.append("p").text("Total visits: " + data.hits);
      var iList = [];
      var i = 0;
      for (user in data.userNames) {
        iList.push(i);
        i = i + 1;
      }
      var rows = mainDiv.append("table").selectAll("tr").data(iList).enter().append("tr");
      rows.append("td").text(function(d) {
        return new Date(1000 * data.timestamps[d]);
      });
      rows.append("td").attr("padding-left", "10px").text(function(d) {
        return data.userNames[d];
      });
      mainDiv.append("hr");
    }
  } else {
    mainDiv.append("h4").text("Selection Data");
    mainDiv.append("span").text("User Name: " + data.userNames[0]);
    mainDiv.append("br");
    mainDiv.append("span").text("Saved At: " + new Date(1000 * data.timestamps[0]));
    mainDiv.append("br");
    mainDiv.append("span").text("Selection Text: ");
    mainDiv.append("br");
    mainDiv.append("br");
    mainDiv.append("p").text("\"" + data.data + "\"");
    mainDiv.append("hr");
  }

  if (type !== 'browse path' && type !== 'domain search' && type !== 'website') {
    mainDiv.append("a")
      .attr('id', 'dd1_btn')
      .attr('class', "btn btn-success")
      .text('Domain Dive')
      .attr('search_term', data.id);
    mainDiv.append("hr");
    var gst = st;
    if (type == 'info') {
      gst = st.split('->')[1].trim();
    }

    $("#dd1_btn").click(function() {
      angular.element(document.getElementById('forensic-body')).scope().domainDive(data)
    });
  }

  // for elastic search results display the _source info
  if (data._source) {
    console.log(data._source)
    mainDiv.append("h3").text("Elastic Search Results")
    mainDiv.append("div").selectAll("p").data(Object.keys(data._source)).enter()
      .append("div")
      .append("p").text(function(d) {
        return d + ":\t" + data._source[d];
      })
  }

  $("#link-dialog").dialog({
    height: 500,
    width: 500,
    position: {
      my: "right top",
      at: "right bottom",
      of: $(".navbar")[0]
    }
    //position: [100,100]
  });
}

// Display links to external tools
function getExternalLinks(mainDiv, type, id) {

  var linksDiv = mainDiv.append("div")
    .style("font-color", "#428bca")
    .style("text-decoration", "underline");

  $.ajax({
    type: "GET",
    url: "/datawake/forensic/tools/get",
    contentType: 'application/json',
    dataType: 'json',
    success: function(links) {

      if (links.length > 0) {
        for (j in links) {
          linkObj = links[j]
          var link = linkObj.link.replace("$VALUE", encodeURI(id))
          if (type == "browse path") {
            queryterm = "website"
          } else {
            queryterm = type
          }
          link = link.replace("$ATTR", encodeURI(queryterm))

          linksDiv.append("a").attr("href", link).attr("target", "_blank").text(linkObj.display)
          linksDiv.append("br")
        }
      } else {
        linksDiv.text("No external tools available.")
      }
    },
    error: function(jqxhr, textStatus, reason) {
      console.log("external link error " + textStatus + " " + reason);
    }
  });
}
