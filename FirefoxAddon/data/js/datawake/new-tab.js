var addon = self;
var newTabApp = angular.module('newTabApp', []);
newTabApp.controller("NewTabCtrl", function ($scope) {

    $scope.isDatawakeOn = false;
    $scope.invalidPreferences = false;
    $scope.newTrail = {};

    addon.port.on("sendDomains", function (domains) {
        $scope.domains = domains;
        $scope.$apply();
    });

    addon.port.on("sendTrails", function (trails) {
        $scope.trails = trails;
        $scope.$apply();
    });

    addon.port.on("sendUserInfo", function (user) {
        $scope.user = user;
        $scope.hideSignInButton = true;
        $scope.$apply();

    });

    addon.port.on("authType", function (auth) {
        $scope.auth = auth;
        if (auth.type == 2) {
            $scope.signIn();
        } else {
            $scope.$apply();
        }
    });

    addon.port.on("versionNumber", function (version) {
        $scope.versionNumber = version;
        $scope.$apply();
    });

    addon.port.on("signOutComplete", function () {
        $scope.hideSignInButton = false;
        $scope.$apply();
    });

    $scope.signIn = function () {
        addon.port.emit("signIn");
    };

    $scope.signOut = function () {
        addon.port.emit("signOut");
    };

    addon.port.on("newTrail", function (trailObject) {
        $scope.trails.push(trailObject);
        $scope.selectedTrail = trailObject;
        $scope.processingNewTrail = false;
        $scope.newTrail.name = "";
        $scope.newTrail.description = "";
        $scope.trailChanged($scope.selectedTrail);
        $scope.$apply();

    });

    addon.port.on("invalidPreferences", function () {
        $scope.invalidPreferences = true;
        $scope.$apply();
    });

    addon.port.on("hasDatawakeInfo", function (previousDatawakeInfo) {
        $scope.selectedTrail = previousDatawakeInfo.trail;
        $scope.selectedDomain = previousDatawakeInfo.domain;
        $scope.isDatawakeOn = previousDatawakeInfo.isDatawakeOn;
        $scope.$apply();
    });

    $scope.datawakeStatusChanged = function (status) {
        console.debug("On Off Was Toggled: " + status);
        $scope.isDatawakeOn = status;
        sendDatawakeInformation();
    };

    $scope.enterKeyEvent = function (keyObject) {
        if (keyObject.keyCode == 13) {
            $scope.createNewTrail();
        }
    };

    $scope.domainChanged = function (domain) {
        var selected = domain.name;
        if (selected != null && selected != "") {
            addon.port.emit("getTrails", selected);
            $scope.selectedTrail = null;
        }
    };

    $scope.trailChanged = function (trail) {
        $scope.processingNewTrailFailed = false;
        sendDatawakeInformation();
    };

    addon.port.on("trailFailure", function () {
        $scope.processingNewTrailFailed = true;
        $scope.processingNewTrail = false;
        $scope.$apply();

    });

    $scope.createNewTrail = function () {
        $scope.processingNewTrail = true;
        addon.port.emit("createTrail", {domain: $scope.selectedDomain.name, trail_name: $scope.newTrail.name, trail_description: $scope.newTrail.description});
    };

    function sendDatawakeInformation() {
        if ($scope.selectedDomain != null && $scope.selectedDomain.name != ""
            && $scope.selectedTrail != null && $scope.selectedTrail.name != "") {
            var dataWake = {};
            dataWake.user = $scope.user;
            dataWake.domain = $scope.selectedDomain;
            dataWake.trail = $scope.selectedTrail;
            dataWake.isDatawakeOn = $scope.isDatawakeOn;
            addon.port.emit("trackingInformation", dataWake);
        }
    }

});