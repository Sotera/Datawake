var addon = self;
var domainLoaderApp = angular.module('domainLoaderApp', ['ng'])
  .directive('fileModel', function($parse) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        var model = $parse(attrs.fileModel);
        var modelSetter = model.assign;
        element.bind('change', function() {
          scope.$apply(function() {
            modelSetter(scope, element[0].files[0]);
            scope.fileName = element[0].files[0].name;

            // HACK for some reason the modelSetter is not working
            // so i will just manually grapb the file object and save it
            scope.fileObj = element[0].files[0]
          });
        });
      }
    };
  })
  .controller("DomainLoaderCtrl", ['$scope', function($scope) {
    $scope.domains = [];
    $scope.teams = [];
    $scope.selectedTeam = null;
    $scope.previewDomain = null;
    $scope.domainPreviewFeatures = null;


    $scope.domain = {
      name: "",
      description: ""
    };


    // TEAMS

    addon.port.on("teams", function(teams) {
      console.log("Domain Manager .on(teams)")
      console.log(teams)
      $scope.teams = teams;
      $scope.selectedTeam = null;
      $scope.$apply();
    });

    $scope.teamChanged = function(team) {
      addon.port.emit("domains", team.id)
    }


    // DOMAINS

    addon.port.on("domains", function(domains) {
      console.log("domain-manager on(domains)")
      console.log(domains)
      $scope.domains = domains
      $scope.$apply()
    });

    $scope.getDomainPreview = function(domain) {
      $scope.previewDomain = domain
      $scope.domainPreviewFeatures = null
      var data = {
        team_id: $scope.selectedTeam.id,
        domain_id: domain.id
      }
      addon.port.emit("domainpreview", data);
    }
    addon.port.on("domainpreview", function(domainSample) {
      console.log("domain-manager on(domainpreview)")
      console.log(domainSample)
      $scope.domainPreviewFeatures = domainSample;
      $scope.$apply()
    });




    $scope.addDomainViaFile = function() {
      console.log("addDomainViaFile")
      console.log("FILE NAME: " + $scope.fileName)
      console.log("FILE OBJ: " + $scope.fileObj)
      var data = {
        team_id: $scope.selectedTeam.id,
        name: $scope.domain.name,
        description: $scope.domain.description,
      }

      // parse the csv file locally and collect a list of features.
      var r = new FileReader();
      r.onload = function(e) {
        try {
          var features = [];
          var contents = e.target.result;
          var lines = contents.split(/\r\n|\n/);
          for (var i = 0; i < lines.length; i++) {
            var line = lines[i]
            var j = line.indexOf(',')
            if (j > 1 || j != line.length - 1) {
              var type = line.substr(0, j)
              var value = line.substr(j + 1)
              if (value[0] == '\"' && value[value.length - 1] == '\"') {
                //strip off enclosing quotes
                value = value.substr(1, value.length - 2)
              }
              features.push({
                type: type,
                value: value
              })
            } else {
              //throw "Invalid line in file: " + line
              //return
            }

          }
          data.features = features;
          console.log(data);

          $scope.domain.name = null;
          $scope.domain.description = null;
          $scope.fileObj = null;
          $scope.$apply();
          addon.port.emit("createDomainFromFile", data)
        } catch (err) {
          alert("A valid csv file is required. \n" + err)
        }

      }
      r.readAsText($scope.fileObj)
    };

    addon.port.on("createdDomain", function(domain) {
      console.log("Created Domain")
      console.log(domain)
      $scope.domains.push(domain)
      $scope.$apply()
    });


    $scope.removeDomain = function(domain) {
      if (confirm("Are you sure you want to remove " + domain.name + "?")) {
        var domains = []
        for (i in $scope.domains) {
          var d = $scope.domains[i]
          if (d.id != domain.id) domains.push(d)
        }
        $scope.domains = domains;
        $scope.$apply();
        var data = {
          team_id: $scope.selectedTeam.id,
          domain_id: domain.id
        }
        addon.port.emit("removeDomain", data)
      }
    }


    addon.port.emit("init");

  }]);