var forensicApp = angular.module('forensicApp', ['ui.grid','ui.grid.selection', 'ui.grid.exporter', 'ui.grid.resizeColumns']);

forensicApp.controller('ForensicController', function ($scope, $filter) {
    $scope.teams = [];
    $scope.domains = [];
    $scope.trails = [];
    $scope.linkGrid = {
      columnDefs: [
        { name: 'URL', cellTemplate:'<div>' +
                       '  <a href="{{row.entity.url}}" target="_blank">{{row.entity.url}}</a>' +
                       '</div>',width: '***'},
        { field: 'title', name: 'Title', width:'**'},
        { field: 'rank', name: "Rank", width:'*' }
      ],
      rowHeight: 40,
      enableGridMenu: true,
      enableSelectAll: true,
      exporterCsvFilename: 'prefetch.csv',
      exporterPdfDefaultStyle: {fontSize: 9},
      exporterPdfTableStyle: {margin: [30, 30, 30, 30]},
      exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
      exporterPdfHeader: { text: "My Header", style: 'headerStyle' },
      exporterPdfFooter: function ( currentPage, pageCount ) {
        return { text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle' };
      },
      exporterPdfCustomFormatter: function ( docDefinition ) {
        docDefinition.styles.headerStyle = { fontSize: 22, bold: true };
        docDefinition.styles.footerStyle = { fontSize: 10, bold: true };
        return docDefinition;
      },
      exporterPdfOrientation: 'portrait',
      exporterPdfPageSize: 'LETTER',
      exporterPdfMaxGridWidth: 500,
      exporterCsvLinkElement: angular.element(document.querySelectorAll(".custom-csv-link-location")),
      onRegisterApi: function(gridApi){
        $scope.gridApi = gridApi;
      }
    };
    $scope.entityGrid = {
      columnDefs: [
        { field: 'name', name: "Name", width:'**' },
        { field: 'type', name: 'Type', width:'**' },
        { field: 'pages', name: 'Pages', width:'*'}
      ],
      enableGridMenu: true,
      enableSelectAll: true,
      exporterCsvFilename: 'entities.csv',
      exporterPdfDefaultStyle: {fontSize: 9},
      exporterPdfTableStyle: {margin: [30, 30, 30, 30]},
      exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
      exporterPdfHeader: { text: "My Header", style: 'headerStyle' },
      exporterPdfFooter: function ( currentPage, pageCount ) {
        return { text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle' };
      },
      exporterPdfCustomFormatter: function ( docDefinition ) {
        docDefinition.styles.headerStyle = { fontSize: 22, bold: true };
        docDefinition.styles.footerStyle = { fontSize: 10, bold: true };
        return docDefinition;
      },
      exporterPdfOrientation: 'portrait',
      exporterPdfPageSize: 'LETTER',
      exporterPdfMaxGridWidth: 500,
      exporterCsvLinkElement: angular.element(document.querySelectorAll(".custom-csv-link-location")),
      onRegisterApi: function(gridApi){
        $scope.gridApi = gridApi;
      }
    };
    $scope.visitedGrid = {
      columnDefs: [
        { name: 'URL', cellTemplate:'<div>' +
                       '  <a href="{{row.entity.url}}" target="_blank">{{row.entity.url}}</a>' +
                       '</div>',width:"***" },
        { field: 'crawl', name: 'Crawl Type', width:'**' },
        { field: 'comments', name: 'Comments', width:'***' },
        { field: 'count', name: "Visits", width:'*' }
      ],
      rowHeight: 40,
      enableGridMenu: true,
      enableSelectAll: true,
      exporterCsvFilename: 'visited.csv',
      exporterPdfDefaultStyle: {fontSize: 9},
      exporterPdfTableStyle: {margin: [30, 30, 30, 30]},
      exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
      exporterPdfHeader: { text: "My Header", style: 'headerStyle' },
      exporterPdfFooter: function ( currentPage, pageCount ) {
        return { text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle' };
      },
      exporterPdfCustomFormatter: function ( docDefinition ) {
        docDefinition.styles.headerStyle = { fontSize: 22, bold: true };
        docDefinition.styles.footerStyle = { fontSize: 10, bold: true };
        return docDefinition;
      },
      exporterPdfOrientation: 'portrait',
      exporterPdfPageSize: 'LETTER',
      exporterPdfMaxGridWidth: 500,
      exporterCsvLinkElement: angular.element(document.querySelectorAll(".custom-csv-link-location")),
      onRegisterApi: function(gridApi){
        $scope.gridApi = gridApi;
      }
    };

    $scope.colorOptions = getOriginalColorOptions()

    $scope.date = {
        startDate: moment({
            hour: 0,
            minute: 0,
            seconds: 0
        }).subtract(365, 'day'),
        endDate: moment({
            hour: 0,
            minute: 0,
            seconds: 0
        })
    };

    // set defaults for elastic search / domain dive credentials
    $scope.esConfig = {
        url: "",
        index: "",
        maxResultsPerNode: 10,
        credentials: "",
        protocol: "https"
    }
    $scope.graphDrawn = false;


    function getOriginalColorOptions() {
        return [{
            text: 'none',
            value: 'none'
        }, {
            text: 'community',
            value: 'community'
        }, {
            text: 'hits',
            value: 'hits'
        }, {
            text: 'timestamp',
            value: 'timestamp'
        }, {
            text: 'user',
            value: 'user'
        }];
    }

    $scope.colorOptions = getOriginalColorOptions()

    /**
     * Get teams for the currently signed in user.
     */
    function get_teams() {
        $.ajax({
            type: "GET",
            url: '/datawake/plugin/teams',
            dataType: 'json',
            success: function (response) {
                console.log("GOT TEAMS")
                console.log(response)
                $scope.teams = response
                $scope.$apply()
            },
            error: function (jqxhr, textStatus, reason) {
                console.error(textStatus + " " + reason);
            }

        });
    }


    /**
     * Get domains for a given team.
     * @param team_id
     */
    function get_domains(team_id) {
        $.ajax({
            type: "GET",
            url: '/datawake/plugin/domains',
            dataType: 'json',
            data: {
                team_id: team_id
            },
            success: function (response) {
                console.log("GOT DOMAINS")
                console.log(response)
                $scope.domains = response
                $scope.$apply()
            },
            error: function (jqxhr, textStatus, reason) {
                console.error(textStatus + " " + reason);
            }
        });
    }


    /**
     * Get the trails for a team/domain
     * @param team_id
     * @param domain_id
     */
    function get_trails(team_id, domain_id) {
        $.ajax({
            type: "GET",
            url: '/datawake/plugin/trails',
            dataType: 'json',
            data: {
                team_id: team_id,
                domain_id: domain_id
            },
            success: function (response) {
                console.log("GOT TRAILS")
                console.log(response)
                $scope.trails = response;
                $scope.$apply()
            },
            error: function (jqxhr, textStatus, reason) {
                console.error(textStatus + " " + reason);
            }
        });
    }


    /**
     * Get the users in a team
     * @param team_id
     */
    function get_users(team_id) {
        $.ajax({
            type: "GET",
            url: '/datawake/forensic/users',
            dataType: 'json',
            data: {
                team_id: team_id
            },
            success: function (response) {
                console.log("GOT USERS")
                console.log(response)
                $scope.users = response;
                // $scope.$apply();
                // $("#user_select").trigger("chosen:updated")
                d3.select("#user_select").selectAll("option").remove();
                var options = d3.select("#user_select").selectAll("option").data(response).enter();
                options.append("option")
                    .attr("value", function (d) {
                        return d.email;
                    })
                    .text(function (d) {
                        return d.email;
                    });
                $("#user_select").trigger("chosen:updated");
            },
            error: function (jqxhr, textStatus, reason) {
                console.error(textStatus + " " + reason);
            }
        });
    }


    /**
     * on team change
     *    - get domains for team
     *    - clear trail and users
     * @param team
     */
    $scope.teamChanged = function (team) {
        $scope.selectedTeam = team;
        console.log("Team changed: ")
        console.log(team)
        $scope.domains = []
        $scope.trails = []
        $scope.users = []
        $scope.selectedUsers = [];
        $scope.selectedDomain = null
        $scope.selectedTrail = null;
        $scope.selectedGraphColoring = null;
        get_domains(team.id)
        get_users(team.id)
    };


    /**
     * on domain change
     *      - get trails for the domain
     * @param domain
     */
    $scope.domainChanged = function (domain) {
        $scope.selectedDomain = domain;
        $scope.trails = [];
        $scope.selectedTrail = null;
        get_trails($scope.selectedTeam.id, domain.id)
    }


    /**
     * Get list of currently selected users
     * @returns {*|jQuery}
     */
    function get_selected_users() {
        var users = $("#user_select").val();
        if (!users) users = [];
        return users;
    }


    $scope.trailChanged = function (trail) {
        $scope.selectedTrail = trail;
        console.log("TRAIL CHANGED")
        console.log($scope.selectedTeam)
        console.log($scope.selectedDomain)
        var users = get_selected_users()
        console.log(users)
        console.log(trail)
        console.log($scope.date)
        // get the time filter data

    }


    function updateTimeSlider(team_id, domain_id, trail_id, users) {
        dateWidget.makeChart(users, trail, domain);
    }


    function list_graphs() {
        $.ajax({
            type: "GET",
            url: '/datawake/forensic/graphservice/list',
            dataType: 'json',
            success: function (data) {
                console.log("GOT VIEWS")
                console.log(data.graphs)
                $scope.views = data.graphs
                $scope.$apply();
            },
            error: function (jqxhr, textStatus, reason) {
                console.log("error " + textStatus + " " + reason);
            }
        });
    }


    $scope.graphViewChanged = function (view) {
        $scope.selectedGraphView = view;
    }

    /**
     * Populate graph coloring options
     * starts with base options and adds types from the current graph
     */
    function populate_highlights() {
        $scope.colorOptions = getOriginalColorOptions();
        for (var type in SWG.node_types) {
            var count = SWG.node_types[type]['count'];
            var newColorOption = {
                text: type + " (" + count + ")",
                value: type
            }
            $scope.colorOptions.push(newColorOption)
        }
        $scope.$apply()
    }

    $scope.drawGraph = function () {
        console.log("drawGraph()")

        // check the start and end date and convert to moment if needed
        if (!$scope.date.startDate._isAMomentObject) {
            $scope.date.startDate = moment($scope.date.startDate.toISOString())
        }
        if (!$scope.date.endDate._isAMomentObject) {
            $scope.date.endDate = moment($scope.date.endDate.toISOString())
        }

        var data = {
            view: $scope.selectedGraphView,
            startdate: $scope.date.startDate.format("X"),
            enddate: $scope.date.endDate.add(1, 'day').format("X"),
            users: get_selected_users(),
            trail_id: $scope.selectedTrail.id,
            domain_id: $scope.selectedDomain.id,
            team_id: $scope.selectedTeam.id
        };
        console.log(data)
        $.ajax({
            type: "POST",
            url: '/datawake/forensic/graphservice/get',
            data: JSON.stringify(data),
            contentType: 'application/json',
            dataType: 'json',
            success: function (graph) {
                console.log("Got back the graph")
                console.log(graph)
                change_graph(graph)
                $scope.graphDrawn = true;
                $scope.$apply()
            },
            error: function (jqxhr, textStatus, reason) {
                console.log("error " + textStatus + " " + reason);
            }
        });
        var entity_request = {
            trail_id: $scope.selectedTrail.id
        };
        $.ajax({
            type: "POST",
            url: "/datawake/forensic/graphservice/entities",
            data: JSON.stringify(entity_request),
            contentType: 'application/json',
            dataType: 'json',
            success: function (incomingData) {
                console.log("Got entities");
                console.log(incomingData)
                $scope.entityGrid.data = [].concat(incomingData);
                $scope.rowEntityCollection = [].concat(incomingData);
                $scope.$apply();
            },
            error: function() {
                console.log("Error getting entities")
                $scope.displayedEntityCollection = [];
                $scope.$apply();
            }
        });
        var link_request = {domain_name: "memex", trail_name:"ufun"}
        $.ajax({
            type: "POST",
            url: "/datawake/forensic/graphservice/links",
            data: JSON.stringify(link_request),
            contentType: 'application/json',
            dataType: 'json',
            success: function (incomingData) {
                console.log("Got links");
                console.log(incomingData)
                $scope.linkGrid.data = [].concat(incomingData);
                $scope.$apply();
            },
            error: function() {
                console.log("Error getting links")
                $scope.apply();
            }
        });
        var visited_request = {trail_id: $scope.selectedTrail.id}
        $.ajax({
            type: "POST",
            url: "/datawake/forensic/graphservice/visited",
            data: JSON.stringify(visited_request),
            contentType: 'application/json',
            dataType: 'json',
            success: function (incomingData) {
                console.log("Got visited");
                console.log(incomingData)
                $scope.visitedGrid.data = [].concat(incomingData);
                $scope.$apply();
            },
            error: function() {
                console.log("Error getting links")
            }
        });
    }


    $scope.graphColoringChanged = function (selectedGraphColoring) {
        console.log(selectedGraphColoring);
        $scope.selectedGraphColoring = selectedGraphColoring;
        change_highlight(selectedGraphColoring)
    }


    /**
     * Search for features in an elastic search index
     * @param one  a single feature to search for, if undefined all features form the graph are pulled
     */
    $scope.domainDive = function (one) {
        var url = $scope.esConfig.url
        var index = $scope.esConfig.index
        var mrpn = $scope.esConfig.maxResultsPerNode
        var credentials = $scope.esConfig.credentials

        console.log('domainDive(' + url + ',' + index + "," + mrpn + ")")
        var jsonData = {
            data: {
                url: url,
                protocol: $scope.esConfig.protocol,
                index: index,
                mrpn: mrpn,
                credentials: credentials,
                search_terms: []
            }
        };


        var nodes = (one === undefined) ? SWG.graph.nodes : [one];
        nodes.forEach(function (node) {
            jsonData.data.search_terms.push({
                type: node['type'],
                id: node['id'],
                data: node['data']
            });
        });
        console.log(jsonData)

        $.ajax({
            type: 'POST',
            url: '/datawake/forensic/domaindive/query',
            data: JSON.stringify(jsonData),
            dataType: 'json',
            contentType: 'application/json',
            success: function (response) {
                console.log("domain dive success")
                console.log(response);
                var nodes = SWG.updateGraph(response);
                nodes.on('click', function (d) {
                    selected_data = d;
                    showLinkDialog(d);
                    SWG.viz.selectAll(".node").style("stroke-width", function (d) {
                        return 0;
                    });
                    d3.select(this).style("stroke", function (d) {
                        return 'yellow';
                    }).style("stroke-width", function (d) {
                        return 4;
                    });

                });
                change_highlight();
            },
            error: function (jqxhr, textStatus, reason) {
                console.log("error " + textStatus + " " + reason)

            }
        });
    }

    // initial set up
    get_teams();
    list_graphs();

});


// add a function to convert a date to an iso string
if (typeof Date.prototype.toISOString !== 'function') {

    (function () {

        'use strict';

        // Function which takes a 1 or 2-digit number and returns
        // it as a two-character string, padded with
        // an extra leading zero, if necessary.
        function pad(number) {
            var r = String(number);
            if (r.length === 1) {
                r = '0' + r;
            }
            return r;
        }

        Date.prototype.toISOString = function () {
            return this.getUTCFullYear() + '-' + pad(this.getUTCMonth() + 1) + '-' + pad(this.getUTCDate()) + 'T' + pad(this.getUTCHours()) + ':' + pad(this.getUTCMinutes()) + ':' + pad(this.getUTCSeconds()) + '.' + String((this.getUTCMilliseconds() / 1000).toFixed(3)).slice(2, 5) + 'Z';
        };

    }());
}
