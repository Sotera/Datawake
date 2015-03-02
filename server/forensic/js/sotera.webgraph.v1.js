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


var SWG = (function() {

  // container for all public functions and objects
  var pubs = {}
  var svg
  var viz
  var Graph
  var render_labels = false
  pubs.viz = viz
  pubs.svg = svg
  pubs.graph = Graph
  pubs.selected_node = undefined
  pubs.node_types = {}
  
  var color = d3.scale.category20();
  pubs.color = color
  
  /*
   * covert node data to text for display
   * applications should override this to display more specific information
   */
  pubs.node_text_func = function(d) { return d.name}
	
  var width = 960
  var height = 500

  // define a force function for use in the graph layout
  var force = d3.layout.force()
    .size([width, height])
  //  .linkStrength(0.25)
    //  .linkDistance(10)
  function setLengthStrength(strength){
     if (strength > 1){
         strength = 1
     }
     force.linkStrength(strength)
     force.stop()
     force.start()
  }
    function setChargeStrength(strength){
        force.charge(strength)
        force.stop()
        force.start()
    }
  pubs.setLengthStrength = setLengthStrength
  pubs.setChargeStrength = setChargeStrength


  /**
   * Display a graph
   * 
   * PARAMS
   * containerId = id of the div elemented dedicated to containing the full screen svg element
   * graph = graph data object.  {'nodes':[{'name':name,'group':group_number,'index':postion_in_array}..],
   *                                'links':[{'source':source node index,'target':target node index},..]}
   *
  */
  function drawGraph(containerId,graph){
	  	var scale = 1;
    	Graph = graph
    	d3.select('#'+containerId).selectAll("svg").remove()
        svg = d3.select('#'+containerId).append("svg")
          .attr({
       	    "width": "100%",
     	    "height": "100%"
     	  })
      	  .attr("viewBox", "0 0 " + width + " " + height )
      	  .attr("preserveAspectRatio", "xMidYMid meet")
      	  .attr("pointer-events", "all")
    	  .call(d3.behavior.zoom().on("zoom", function(){
    		scale = d3.event.scale;
    	    viz.attr("transform",
              "translate(" + d3.event.translate + ")"
                + " scale(" + d3.event.scale + ")");
    	  }));
          svg.append("defs").append("marker")
              .attr("id", "arrowhead")
              .attr("refX", 6 + 3) /*must be smarter way to calculate shift*/
              .attr("refY", 2)
              .attr("markerWidth", 6)
              .attr("markerHeight", 4)
              .attr("orient", "auto")
              .append("path")
              .attr("d", "M 0,0 V 4 L6,2 Z"); //this is actual shape for arrowhead
    	
    	viz = svg.append('svg:g');
    	pubs.viz = viz
    	
    	var nodes = graph.nodes.slice()
    	var links = []
        var bilinks = []
        
        // iterate over nodes to collect type information
        pubs.node_types = {}
        for (var i in nodes){
		  var node = nodes[i]
		  if (node.name){
		    var nodetext = node.name.toLowerCase()
			var type = nodetext.substring(0,nodetext.indexOf(":"))
			if (type.length > 0) {
			  if (type in pubs.node_types) pubs.node_types[type]['count'] += 1
			  else pubs.node_types[type] = {'count':1 ,'group':node.group}
			}
		  }
		}
        
        graph.links.forEach(function(link) {
    	  var s = nodes[link.source],
       	  t = nodes[link.target],
          i = {}; // intermediate node
    	  nodes.push(i);
    	  links.push({source: s, target: i}, {source: i, target: t});
    	  bilinks.push([s, i, t]);
  		});
  			
  		force.nodes(nodes).links(links).start();
  		
  		// TODO look for css like .node and .link, that will need to be pulled into a sotera.webgraph.css file
  		
  		var link = viz.selectAll(".link")
      	  .data(bilinks)
    	  .enter().append("path")
      	  .attr("class", "link");
      			
        var node = viz.selectAll(".node")
      	  .data(graph.nodes)
    	  .enter().append("g")
    	  .attr("class", "node");
    	
    	node.append("svg:circle")
      	  .attr("r", function(d) {
            if (d.size) return d.size
            else return 5
            })
      	  .style("fill", function(d) { return color(d.group); })
      	  .call(force.drag);
      	  
      	// on click show text clicked node and neighbors
      	node.on("click", function(d){
   		  pubs.selected_node = d
   		  if (!d.clicked) d.clicked = true
		  else d.clicked = !d.clicked
		  connected = [d.index]
		  for (var i in bilinks){
		    var curr = bilinks[i]
			if ( curr[0].index == d.index)  connected.push(curr[2].index)
			else if (curr[2].index == d.index) connected.push(curr[0].index)
		  }
		  viz.selectAll(".node").selectAll("svg text").remove()
		  if (d.clicked){
		    d3.select(this).append("svg:text")
			  .text(pubs.node_text_func)
			  .attr("fill","black")
			  .attr("stroke","black")
			  .attr("font-size","5pt")
			  .attr("stroke-width","0.5px")
			viz.selectAll(".node").each(function(d){
			  if (connected.indexOf(d.index) != -1) {
			    d3.select(this).append("svg:text")
				  .text(pubs.node_text_func)
				  .attr("fill","black")
				  .attr("stroke","black")
				  .attr("font-size","5pt")
				  .attr("stroke-width","0.5px")
			  }
		    })
		  }
		});  
		
		// show detailed label on mouseover
		node.on("mouseover", function(d) { 
		  d3.select(this).append("svg:text")
  		    .text(pubs.node_text_func)
			.attr("transform","scale("+(1/scale)+")")
 			.attr("fill","black")
 			.attr("stroke","black")
 			.attr("font-size","8pt")
 			.attr("stroke-width","0.5px")
		})
		
		// remove text on mouse out
		node.on("mouseout", function() {
		  d3.select(this).select("svg text").remove()
 		}) 
 		
 		
 		// render node labels if requested
 		if (render_labels){
		  node.append("svg:text")
  		    .text(pubs.node_text_func)
 			.attr("fill","black")
 			.attr("stroke","black")
 			.attr("font-size","5pt")
 			.attr("stroke-width","0.5px")
 		}
 		
 		// force layout
 		force.on("tick", function() {
    	  link.attr("d", function(d) {
      	    return "M" + d[0].x + "," + d[0].y + "S" + d[1].x + "," + d[1].y + " " + d[2].x + "," + d[2].y;
  		  });
          node.attr("transform", function(d) {
      	    return "translate(" + d.x + "," + d.y + ")";
    	  });  
        });

    	  
  } // end draw graph
  pubs.drawGraph = drawGraph
  
  
  /*
   * Toogle on / off all node labels
   */
  function toogleLabels(){
    if (viz && render_labels) {
    	  viz.selectAll(".node").selectAll("svg text").remove()
    }
    else if (viz){
      viz.selectAll(".node")
	    .append("svg:text")
  	    .text(pubs.node_text_func)
 		.attr("fill","black")
 		.attr("stroke","black")
 		.attr("font-size","5pt")
 		.attr("stroke-width","0.5px")
    }
  	render_labels = ! render_labels
  
  }
  pubs.toogleLabels = toogleLabels
  
  
  function clear_legend() {
    d3.select('#legend').selectAll("svg text").remove()
    d3.select('#legend').selectAll("svg rect").remove()
  }
  pubs.clear_legend = clear_legend
  
  
  function show_base_legend(){
    show_legend(Object.keys(pubs.node_types),function(d) { return color(pubs.node_types[d]['group'])})
  }
  pubs.show_base_legend = show_base_legend

  function show_legend(keys,colorFunc){
    // Construct a color legend.
    $("#legend").svgColorLegend({
      cmapFunc: colorFunc,
      xoffset: 10,
      yoffset: 10,
      categories: keys,
      heightPadding: 5,
      widthPadding: 7,
      textSpacing: 19,
      legendMargins: {top: 5, left: 5, bottom: 5, right: 5},
      clear: true
    });
  }
  pubs.show_legend = show_legend
  
  
  function defaultColors(){
    show_base_legend()
	viz.selectAll("svg circle")
		.attr("r", function(d) {
            if (d.size) return d.size
            else return 5
        })
		.style("fill", function(d) { return color(d.group)})
  }
  pubs.defaultColors = defaultColors
  
  function highlightType(type){
    console.log("highlight nodes of type: "+type)
    var colorFunc = function(d) {
      if (d == 'other') return "grey"
      return color(SWG.node_types[d]['group']) 
    } 
    show_legend([type,'other'],colorFunc)
    viz.selectAll("svg circle")
		.attr("r", function(d) {
			if (d.name.toLowerCase().indexOf(type) == 0){ 
			  return 8 
			}
			else {return 5} 
		})
    	.style("fill", function(d) { 
			if (d.name.toLowerCase().indexOf(type) == 0){ return color(d.group) }
			else { return "grey" }
		})
  }
  pubs.hightlightType = highlightType
  
  
  
  function showTypeDialog(type){
    data = []
    var nodes = Graph.nodes.slice()
    for (i in nodes){
      var node = nodes[i]
      if (node.name.toLowerCase().indexOf(type) == 0){
        data.push(pubs.node_text_func(node))
      }
    }
    
    $("#dialog").dialog().dialog("close")
    d3.select("#dialog").selectAll("div").remove()
    $("#dialog").dialog().dialog('option','position',[100,100])
    var rows = d3.select("#dialog")
        .append("div")
        .attr("class","highlighed_verts_dialog")
	  .append("table")
        .attr("border","1")
	  .selectAll("tr")
	  .data(data).enter()
	    .append("tr")
		.append("td")
		.attr("padding-left","5px")
		.text(function(d){ return d})
		.style("border", "1px black solid")
        .style("padding", "5px")
        .style("font-size","10px")
        .style("font-weight","bold")
        
    $("#dialog").dialog().dialog("option","height","auto")
    $("#dialog").dialog().dialog("option","width","auto")  
  }
  pubs.showTypeDialog = showTypeDialog
  
  
  return pubs
})();