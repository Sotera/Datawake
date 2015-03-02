var self = require("sdk/self");
var data = self.data;
var addOnPrefs = require("sdk/simple-prefs").prefs;
var controller = require("./controller");
var tabs = require("sdk/tabs");
var requestHelper = require("./request-helper");
var constants = require("./constants");
var storage = require("./storage");
var timer = require("sdk/timers");
var service = require("./service");
var selectionHelper = require("./selections");
var notifications = require("sdk/notifications");

exports.setUpTab = setUpTab;
exports.trackTab = trackTab;
exports.emitHighlightTextToTabWorker = emitHighlightTextToTabWorker;
exports.highlightTrailEntities = highlightTrailEntities;
exports.hideSelections = hideSelections;
exports.highlightTextWithToolTips = highlightTextWithToolTips;
exports.promptForExtractedFeedback = promptForExtractedFeedback;
exports.isTabWorkerAttached = isTabWorkerAttached;


/*
    TODO, this addon sets up new workers on a tab on every "ready" event.
    In Theory we should be able to create the tab worker just once when
    a new tab is opened but that method was problematic.  Further
    ivestigation is required.

*/


/**
 * Storage object for tracking tabs
 * @type {{Dictionary}}
 */
var trackingTabWorkers = {};


/**
 * Provide a user notification
 * @param message
 */
function notify(message){
    notifications.notify({
        title: "Datawake Notice",
        text: message,
        iconURL: self.data.url("img/waveicon38.png")
    });
}


/**
 * Sets up event listeners for the tab to allow posting of content.
 * Should be called for every tab at creation.
 *
 * @param tab The tab to track.
 */
function setUpTab(tab) {
    var tabId = tab.id;
    tab.on("ready",trackTab)
    tab.on('close', function (other) {
        close(tabId);
    });
}

/**
 * If recording is on load scripts into the tab to track page contents.
 * @param tab
 */
function trackTab(tab){
    // in the event that there is already a worker for this tab destroy it.
    destoryTabWorker(tab.id);

    var datawakeInfoForTab = storage.getDatawakeInfo(tab.id);
    if (!datawakeInfoForTab.isDatawakeOn) {
        if (datawakeInfoForTab.team && datawakeInfoForTab.domain && datawakeInfoForTab.trail){
            notify("Attention:  Datawake is setup but has not been started.")
        }
        return;
    }

    var trackingTabWorker = tab.attach({
        contentScriptFile: [
            data.url("js/min/jquery-1.11.1.min.js"),
            data.url("js/min/jquery-ui-1.10.4.custom.min.js"),
            data.url("js/min/jquery.highlight-4.js"),
            data.url("js/min/jquery.tooltipster.min.js"),
            data.url("js/datawake/tracking.js")
         ]
    });
    setTabWorker(tab.id, trackingTabWorker);

    //Loads CSS files in jQuery
    trackingTabWorker.port.on("getToolTips", function () {
        trackingTabWorker.port.emit("loadToolTips", [
            data.url("css/tooltipster.css"),
            data.url("css/tooltipster-noir.css"),
            data.url("css/tooltipster-punk.css"),
            data.url("css/highlight.css")
        ]);
    });

    //Posts the scrape contents to the server.
    trackingTabWorker.port.on("contents", function (pageContents) {


        var currentTrackingTabWorker = trackingTabWorkers[tab.id];
        var datawakeInfoForTab = storage.getDatawakeInfo(tab.id);
        if (addOnPrefs.useScraper && datawakeInfoForTab && datawakeInfoForTab.isDatawakeOn) {


            console.debug("Scraping Page");
            pageContents.url = currentTrackingTabWorker.tab.url;
            pageContents.domain_id = datawakeInfoForTab.domain.id;
            pageContents.trail_id = datawakeInfoForTab.trail.id;
            pageContents.team_id = datawakeInfoForTab.team.id;

            var url = addOnPrefs.datawakeDeploymentUrl + "/scraper/scrape";
            requestHelper.post(url, JSON.stringify(pageContents), function (response) {

                if (response.status != 200){
                    if (response.body) controller.notifyError(response.body);
                    console.error(response);
                    return;
                }

                notify("Success: Page recorded.")
                controller.getFeaturesForPanel(datawakeInfoForTab);  // re-fetch features for the panel



                //Sets up the context menu objects for this tab.
                if (currentTrackingTabWorker.tab != null) {
                    getDomainExtractedEntities();
                }
            });
        }
        selectionHelper.useContextMenu(currentTrackingTabWorker.tab);
    });

}




function promptForExtractedFeedback(highlightedText, callback) {
    var currentTrackingTabWorker = trackingTabWorkers[tabs.activeTab.id];
    var obj = {};
    obj.raw_text = highlightedText;
    currentTrackingTabWorker.port.emit("promptForFeedback", obj);
    currentTrackingTabWorker.port.once("feedback", function (response) {
        callback(response.type, response.value);
    });
}

function hideSelections(className) {
    var currentTrackingTabWorker = trackingTabWorkers[tabs.activeTab.id];
    currentTrackingTabWorker.port.emit("removeSelections", className);
}

function highlightTrailEntities(entities) {
    var currentTrackingTabWorker = trackingTabWorkers[tabs.activeTab.id];
    currentTrackingTabWorker.port.emit("highlightTrailEntities", entities);
}


/**
 * Gets all entities associated for this url
 * @param delay Timeout delay between each call.
 */
function getDomainExtractedEntities() {
    if (isTabWorkerAttached(tabs.activeTab.id) && constants.isValidUrl(tabs.activeTab.url)) {
        var datawakeInfo = storage.getDatawakeInfo(tabs.activeTab.id);
        var tabUrl = tabs.activeTab.url;
        service.getDomainExtractedEntities(datawakeInfo.team.id,datawakeInfo.domain.id, tabUrl, function (response) {
                if (response.status != 200){
                    console.error("Error getting domain entities in tracking.js")
                    return;
                }
                var entitiesInDomain = response.json;
                highlightExtractedLinks(entitiesInDomain);
                if (Object.keys(entitiesInDomain).length > 0) {
                    console.debug("Domain matches found on url: " + tabUrl + " setting badge RED");
                    //TODO: When badges get added, change the color here.
                } else {
                    console.debug("no domain matches found on url: " + tabUrl);
                }
        });
    }
}

/**
 * Gets the entities in this domain.
 * @returns {Array} The entities that are in this domain.
 * @param domainExtracted
 */
function getEntitiesInDomain(domainExtracted) {
    var entitiesInDomain = [];
    for (var type in domainExtracted) {
        for (var index in domainExtracted[type]) {
            var typeObject = {};
            typeObject.type = type;
            typeObject.name = domainExtracted[type][index];
            console.debug("Extracted value: " + typeObject.name);
            entitiesInDomain.push(typeObject);
        }
    }
    return entitiesInDomain;
}

/**
 * Gets the external links for this instance and highlights the entities in the array.
 * @param entitiesInDomain Entities to highlight.
 */
function highlightExtractedLinks(entitiesInDomain) {
    service.getExternalLinks(function (externalLinks) {
        var highlightObject = {};
        highlightObject.entities = entitiesInDomain;
        highlightObject.links = externalLinks;
        console.debug("Emitting data to highlight");
        highlightTextWithToolTips(tabs.activeTab.id, highlightObject);
    });
}

/**
 * Sends the highlight object to the tab worker.
 * @param tabId The tab id to get the worker.
 * @param highlightList The highlight information to send.
 */
function emitHighlightTextToTabWorker(tabId, highlightList) {
    var currentTrackingTabWorker = trackingTabWorkers[tabId];
    currentTrackingTabWorker.port.emit("highlight", highlightList);
}

/**
 * Highlights text with tooltips.
 * @param tabId The id of the tab to highlight.
 * @param helperObject The helper object to forward to the worker.
 */
function highlightTextWithToolTips(tabId, helperObject) {
    if (trackingTabWorkers.hasOwnProperty(tabId) && addOnPrefs.useHighlighting) {
        var tabWorker = trackingTabWorkers[tabId];
        tabWorker.port.emit("highlightWithToolTips", helperObject);
    }
}

/**
 * A method that checks to see if a tab is attached to a worker.
 * @param tabId The tab id to check.
 * @returns {boolean} True if the worker exists and there is a tab associated with it.
 */
function isTabWorkerAttached(tabId) {
    return trackingTabWorkers.hasOwnProperty(tabId) && trackingTabWorkers[tabId].tab != null;
}

/**
 * Destroys a worker associated with a tab.
 * @param tabId The tab id of the worker to destory.
 */
function destoryTabWorker(tabId) {
    if (trackingTabWorkers.hasOwnProperty(tabId)) {
        trackingTabWorkers[tabId].destroy();
    }
}

/**
 * Associated a worker and tab id.
 * @param tabId Tab Id to associate worker.
 * @param worker Worker to associate.
 */
function setTabWorker(tabId, worker) {
    destoryTabWorker(tabId);
    trackingTabWorkers[tabId] = worker;
}


/**
 * The on close event for a tab.
 * @param tabId Tab Id being closed.
 */
function close(tabId) {
    destoryTabWorker(tabId);
    selectionHelper.cleanUpTab(tabId);
    storage.deleteDatawakeInfo(tabId);
}