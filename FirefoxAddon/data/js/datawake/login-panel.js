var addon = self;


var loginApp = angular.module('LoginApp', []);

loginApp.controller("LoginCtrl", function ($scope) {

    $scope.invalidPreferences = false;
    $scope.hideSignInButton = false;


    addon.port.on("sendUserInfo", function (user) {
        console.debug("login-panel got user info")
        console.debug(user)
        $scope.user = user;
        $scope.hideSignInButton = true;
        $scope.$apply();

    });


    addon.port.on("signOutComplete", function () {
        $scope.hideSignInButton = false;
        $scope.user = null;
        $scope.$apply();
    });


    $scope.signIn = function(){
        addon.port.emit("signIn");
    }

    $scope.signOut = function(){
        addon.port.emit("signOut");
    }


    addon.port.on("invalidPreferences", function () {
        console.debug("login-panel invalidePreferences")
        $scope.invalidPreferences = true;
        $scope.$apply();
    });


});

