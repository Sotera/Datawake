/**
 * Helper Functions
 */
var addOnPrefs = require("sdk/simple-prefs").prefs;
var tabs = require("sdk/tabs");
var self = require("sdk/self");
var data = self.data;

var authHelper = require("./auth-helper");
var trackingHelper = require("./tracking");
var constants = require("./constants");
var storage = require("./storage");
var requestHelper = require("./request-helper");
var preferenceValidator = require("./preference-validator");


exports.useDatawake = useDatawake;

var newtabPageMod;
var signedIn = false;
/**
 * Gets the domains from the server.
 * @param callback Response callback.
 */
/*
function getDomains(callback) {
    var url = addOnPrefs.datawakeDeploymentUrl + "/domains";
    requestHelper.get(url, callback);
}*/

/**
 * Gets the trails for a specific domain.
 * @param domain Domain to use to get trails.
 * @param callback Response callback.
 */
/*
function getTrails(domain, callback) {
    var url = addOnPrefs.datawakeDeploymentUrl + "/trails/get";
    var post_data = JSON.stringify({
        domain: domain
    });
    requestHelper.post(url, post_data, callback);
}*/

/**
 * Function for setting up a new tab and it's listeners.
 * @param worker Object for communicating with the new tab content.
 */
function setupNewTabListener(worker) {
    if (preferenceValidator.preferencesAreValid()) {

        if (storage.hasDatawakeInfoForTab(tabs.activeTab.id))
            worker.port.emit("hasDatawakeInfo", storage.getDatawakeInfo(tabs.activeTab.id));

        //Gets the trails for the specific domain and emits them back.
        worker.port.on("getTrails", function (domain) {
            console.debug("Getting trails for " + domain + "!");
            getTrails(domain, function (response) {
                if (response.status != 501) {
                    worker.port.emit("sendTrails", response.json.trails);
                } else {
                    console.error("There was an error getting trails: " + response.message);
                }
            });
        });

        worker.port.on("signIn", function () {
            console.debug("overlay.js signIn")
            authHelper.signIn(function (response) {
                //Just a work around due to the activeTab issue.
                //SEE: https://bugzilla.mozilla.org/show_bug.cgi?id=942511
                signedIn = true;
                if (authHelper.authType() == 1) {
                    tabs.open("about:newtab");
                    worker.tab.close();
                    worker.destroy();
                } else {
                    worker.port.emit("sendUserInfo", response.json);
                    getDomains(function (response) {
                        console.debug("Emitting Domains");
                        worker.port.emit("sendDomains", response.json);
                    });
                }
            });
        });

        worker.port.emit("versionNumber", self.version);

        worker.port.on("signOut", function () {
            signedIn = false;
            authHelper.signOut(function (response) {
                worker.port.emit("signOutComplete");
            });
        });

        //Handles creating a trail for a domain.
        worker.port.on("createTrail", function (obj) {
            createTrail(obj.domain, obj.trail_name, obj.trail_description, function (response) {
                if (response.status == 501) {
                    worker.port.emit("trailFailure");
                } else {
                    var jsonResponse = response.json;
                    if (jsonResponse.success) {
                        console.debug("Sending successful trail back to worker.");
                        worker.port.emit("newTrail", {
                            name: obj.trail_name,
                            description: obj.trail_description
                        });
                    }
                }
            });
        });

        //Sets the tracking information for a tab.
        worker.port.on("trackingInformation", function (datawakeInfo) {
            console.debug("Datawake tracking process updated.  Tracking is on: " + datawakeInfo.isDatawakeOn);
            trackingHelper.trackTab(worker.tab, datawakeInfo);
        });

        var auth = {};
        auth.type = authHelper.authType();
        worker.port.emit("authType", auth);

        //Sends the domains to the newtab overlay
        //Commented out for now
        //A work around due to a bug in firefox SEE: Line 68
        if (auth.type == 1 && signedIn) {
            authHelper.getLoggedInUser(function (user) {
                if (!(user.status == 501)) {
                    worker.port.emit("sendUserInfo", user.json.user);
                    getDomains(function (response) {
                        console.debug("Emitting Domains");
                        worker.port.emit("sendDomains", response.json);
                    });
                }
            });
        }
    } else {
        worker.port.emit("invalidPreferences");
    }


}

/**
 * Method that creates a trail.
 * @param domain The domain to create the trail under.
 * @param trailname The new trail name.
 * @param traildescription The trails description.
 * @param callback Response callback.
 */
function createTrail(domain, trailname, traildescription, callback) {
    var url = addOnPrefs.datawakeDeploymentUrl + "/trails/create";
    var post_data = JSON.stringify(
        {
            domain: domain,
            trailname: trailname,
            traildescription: traildescription
        });
    requestHelper.post(url, post_data, callback);
}

/**
 * Triggers the datawake and the page modification for a new tab.
 */
function useDatawake() {
    /*
    newtabPageMod = require("sdk/page-mod").PageMod({
        include: data.url("html/datawake-tab-panel.html"),
        contentScriptFile: [
            data.url("js/min/jquery-1.11.1.min.js"),
            data.url("js/min/angular.min.js"),
            data.url("js/min/bootstrap.min.js"),
            data.url("js/min/bootstrap-switch.min.js"),
            data.url("js/datawake/new-tab.js")
        ],
        onAttach: setupNewTabListener
    });*/

    tabs.on("open", function (tab) {
        var datawakeInfo = storage.getRecentlyUsedDatawakeInfo();
        if (datawakeInfo != null) {
            trackingHelper.trackTab(tab, datawakeInfo);
        }
    });
}

