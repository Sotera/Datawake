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

var domainLoaderApp = angular.module('domainLoaderApp', []);

domainLoaderApp.controller("DomainLoaderCtrl", function ($scope, $timeout, domainService) {
    $scope.domains = [];

    domainService.getVersionNumber().then(function (response){
        $scope.versionNumber = response.version;
    });

    $scope.domain = {
        name: "",
        description: "",
        connection: "",
        table: "",
        attribute: "",
        value: "",
        file: undefined
    };

    var poll = function () {
        domainService.poll()
            .then(function (result) {
                if (result.complete) {
                    $scope.domains.push({name: result.domain, description: result.description})
                }
                else {
                    $timeout(poll, 5000);
                }
            }, function (errorMessage) {
                console.warn(errorMessage);
            });
    };

    $scope.addDomainViaFile = function () {
        domainService.addDomainViaFile($scope.domain.name, $scope.domain.description, $scope.domain.file)
            .then(function(){
                window.location.reload();
            }, function (errorMessage) {
                console.warn(errorMessage);
            });
        $scope.domain.name = "";
        $scope.domain.description = "";
    };

    $scope.getPreview = function (domain) {
        domainService.getPreview(domain.name)
            .then(function (previews) {
                domain.preview = previews;
                domain.show = !domain.show;
            },
            function (errorMessage) {
                console.warn(errorMessage);
            });
    };

    $scope.addDomainViaConnectionString = function () {
        domainService.addDomainViaConnectionString(
            $scope.domain.name,
            $scope.domain.description,
            $scope.domain.connection,
            $scope.domain.table,
            $scope.domain.attribute,
            $scope.domain.value)
            .then($timeout(poll, 5000), function (errorMessage) {
                console.warn(errorMessage);
            });
        $scope.domain.name = "";
        $scope.domain.description = "";
        $scope.domain.connection = "";
        $scope.domain.table = "";
        $scope.domain.attribute = "";
        $scope.domain.value = "";
    };

    $scope.removeDomain = function (domain) {
        if (confirm("Are you sure you want to remove " + domain.name + "?")) {
            domainService.deleteDomain(domain.name)
                .then(loadDomains, function (errorMessage) {
                    console.warn(errMessage);
                });
        }
    };

    loadDomains();

    function applyUpdate(domains) {
        $scope.domains = domains;
    }

    function loadDomains() {
        domainService.getDomains().then(function (domains) {
            applyUpdate(domains);
        });
    }
});

domainLoaderApp.directive('fileModel', function ($parse) {
    return{
        restrict: 'A',
        link: function (scope, element, attrs) {
            var model = $parse(attrs.fileModel);
            var modelSetter = model.assign;
            element.bind('change', function () {
                scope.$apply(function () {
                    modelSetter(scope, element[0].files[0]);
                    scope.fileName = element[0].files[0].name;
                });
            });
        }
    };
});

domainLoaderApp.service("domainService", function ($http, $q) {
    return({
        getDomains: getDomains,
        addDomainViaFile: addDomainViaFile,
        addDomainViaConnectionString: addDomainViaConnectionString,
        deleteDomain: deleteDomain,
        getPreview: getPreview,
        poll: poll,
        getVersionNumber: getVersionNumber
    });

    function getVersionNumber(){
        var request = $http({
            method: "get",
            url: "/datawake/version/number"
        });
        return request.then(handleSuccess, handleError);
    }
    function poll() {
        var request = $http({
            method: "get",
            url: "/datawake/domain/loader/poll"
        });
        return request.then(handleSuccess, handleError);
    }

    function getPreview(name) {
        var formData = new FormData();
        formData.append("domain", name);
        var request = $http({
            method: "post",
            url: "/datawake/domain/loader/preview",
            transformRequest: angular.identity,
            headers: {
                'Content-Type': undefined
            },
            data: formData
        });
        return request.then(handleSuccess, handleError);
    }

    function getDomains() {
        var request = $http({
            method: "get",
            url: "/datawake/domain/loader/domains"
        });
        return(request.then(handleSuccess, handleError));
    }

    function deleteDomain(name) {
        var formData = new FormData();
        formData.append("domain_name", name);
        var request = $http({
            method: 'post',
            url: '/datawake/domain/loader/delete',
            data: formData,
            transformRequest: angular.identity,
            headers: {
                'Content-Type': undefined
            }
        });
        return(request.then(handleSuccess, handleError));
    }

    function addDomainViaConnectionString(name, description, connection, table, attribute, values) {
        var url = '/datawake/domain/loader/upload-database';
        var formData = new FormData();
        formData.append("domain_name", name);
        formData.append("domain_description", description);
        formData.append("connection_string", connection);
        formData.append("attribute_column", attribute);
        formData.append("value_column", values);
        formData.append("table_name", table);
        var request = $http({
            method: "post",
            url: url,
            transformRequest: angular.identity,
            headers: {
                'Content-Type': undefined
            },
            data: formData
        });
        return (request.then(handleSuccess, handleError));
    }

    function addDomainViaFile(name, description, file) {
        var formData = new FormData();
        formData.append("file_upload", file);
        formData.append("name", name);
        formData.append("description", description);
        var request = $http({
            method: "post",
            url: "/datawake/domain/loader/upload",
            transformRequest: angular.identity,
            headers: {
                'Content-Type': undefined
            },
            data: formData
        });
        return (request.then(handleSuccess, handleError));
    }

    function handleError(response) {
        if (!angular.isObject(response.data) || !response.data.message) {
            return( $q.reject("An unknown error occurred.") );
        }
        return( $q.reject(response.data.message) );

    }

    function handleSuccess(response) {
        return( response.data );

    }
});