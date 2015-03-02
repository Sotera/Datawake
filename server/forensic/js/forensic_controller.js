
var forensicApp = angular.module('forensicApp', ['daterangepicker']);

forensicApp.controller('ForensicController', function ($scope) {
    $scope.teams = [];
    $scope.domains = [];
    $scope.trails = [];
    //$scope.users = [];
    //$scope.selectedUsers=[];
    $scope.colorOptions = getOriginalColorOptions()

    $scope.date = {startDate: moment({hour:0,minute:0,seconds:0}).subtract(7, 'day'), endDate: moment({hour:0,minute:0,seconds:0}) };


    function getOriginalColorOptions(){
        return [
            {text:'none',value:'none'},
            {text: 'community',value:''},
            {text: 'hits',value:''},
            {text: 'timestamp',value:''},
            {text: 'user',value:''}
        ];
    }
    $scope.colorOptions = getOriginalColorOptions()

    /**
     * Get teams for the currently signed in user.
     */
    function get_teams(){
        $.ajax({
            type: "GET",
            url: '/datawake/plugin/teams',
            dataType: 'json',
            success: function (response) {
                console.log("GOT TEAMS")
                console.log(response)
                $scope.teams=response
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
    function get_domains(team_id){
        $.ajax({
            type: "GET",
            url: '/datawake/plugin/domains',
            dataType: 'json',
            data: {team_id: team_id },
            success: function (response) {
                console.log("GOT DOMAINS")
                console.log(response)
                $scope.domains=response
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
    function get_trails(team_id,domain_id){
        $.ajax({
            type: "GET",
            url: '/datawake/plugin/trails',
            dataType: 'json',
            data: {team_id: team_id , domain_id: domain_id},
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
    function get_users(team_id){
        $.ajax({
            type: "GET",
            url: '/datawake/forensic/users',
            dataType: 'json',
            data: {team_id:team_id},
            success: function (response) {
                console.log("GOT USERS")
                console.log(response)
               // $scope.users = response;
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
       console.log("Team changed: ")
       console.log(team)
       $scope.domains = []
       $scope.trails = []
       $scope.users = []
       $scope.selectedUsers=[];
       $scope.selectedDomain = null
       $scope.selectedTrail = null;
       get_domains(team.id)
       get_users(team.id)
    };




    /**
     * on domain change
     *      - get trails for the domain
     * @param domain
     */
    $scope.domainChanged = function(domain){
        $scope.trails= [];
        $scope.selectedTrail = null;
        get_trails($scope.selectedTeam.id,domain.id)
    }


    /**
     * Get list of currently selected users
     * @returns {*|jQuery}
     */
    function get_selected_users() {
        var users =  $("#user_select").val();
        if (!users) users = [];
        return users;
    }


    $scope.trailChanged = function(trail){
        console.log("TRAIL CHANGED")
        console.log($scope.selectedTeam)
        console.log($scope.selectedDomain)
        var users = get_selected_users()
        console.log(users)
        console.log(trail)
        console.log($scope.date)
        // get the time filter data

    }


    function updateTimeSlider(team_id,domain_id,trail_id,users) {
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


    /**
     * Populate graph coloring options
     * starts with base options and adds types from the current graph
     */
    function populate_highlights() {
        $scope.colorOptions = getOriginalColorOptions();
        for (var type in SWG.node_types) {
            var count = SWG.node_types[type]['count'];
            var newColorOption={text: type + " (" + count + ")", value: type}
            $scope.colorOptions.push(newColorOption)
        }
        $scope.$apply()
    }

    $scope.drawGraph = function(){
        console.log("drawGraph()")
        var data = {
            view: $scope.selectedGraphView,
            startdate: $scope.date.startDate.format("X"),
            enddate: $scope.date.endDate.add(1,'day').format("X"),
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
            },
            error: function (jqxhr, textStatus, reason) {
                console.log("error " + textStatus + " " + reason);
            }
        });

    }

    // initial set up
    get_teams();
    list_graphs();


});