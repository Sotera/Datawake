exports.getDatawakeInfo = getDatawakeInfo;
exports.setDatawakeInfo = setDatawakeInfo;
exports.deleteDatawakeInfo = deleteDatawakeInfo;
exports.hasDatawakeInfoForTab = hasDatawakeInfoForTab;
exports.getRecentlyUsedDatawakeInfo = getRecentlyUsedDatawakeInfo;
exports.clear = clear;


/*  Maps tabid -> datawakeinfo object*/
var datawakeInfoStorage = {};

/* datawakeinfo object for most recently active tab */
var lastUsedDatawakeInfo = null;


/**
 * Clear all storage
 */
function clear(){
   datawakeInfoStorage = {}
   lastUsedDatawakeInfo = null;
}

/**
 * Create a new datawakeinfo object
 * @returns new blank datawakeinfo object
 */
function newDatawakeInfo(){
    var dataWake = {};
    dataWake.domain = null;
    dataWake.trail = null;
    dataWake.isDatawakeOn = false;
    dataWake.team = null;
    return dataWake;
}


/**
 * Copies a datawakeinfo object
 * @param original
 * @returns new object with copied fields
 */
function copyDatawakeInfo(original){
    var copy = newDatawakeInfo();
    copy.domain = original.domain;
    copy.trail = original.trail;
    copy.isDatawakeOn = original.isDatawakeOn;
    copy.team = original.team;
    return copy
}


/**
 * Function for getting the datawake information associated with a tab.
 * @param tabId The tab's Id
 * @returns {*} Datawake Info Object.
 */
function getDatawakeInfo(tabId) {
    if (!hasDatawakeInfoForTab(tabId)) {
        datawakeInfoStorage[tabId] = newDatawakeInfo()
    }
    lastUsedDatawakeInfo = datawakeInfoStorage[tabId];
    return datawakeInfoStorage[tabId];
}


/**
 * Sets the Datawake info for a specific tab.
 * @param tabId The tab's Id to associate the data with.
 * @param datawakeInfo The data to set.
 */
function setDatawakeInfo(tabId, datawakeInfo) {
    deleteDatawakeInfo(tabId);
    datawakeInfoStorage[tabId] = datawakeInfo;
    lastUsedDatawakeInfo = datawakeInfo;
}

function getRecentlyUsedDatawakeInfo(){
    if (lastUsedDatawakeInfo == null){
        lastUsedDatawakeInfo = newDatawakeInfo();
        return lastUsedDatawakeInfo;
    }
    return copyDatawakeInfo(lastUsedDatawakeInfo);
}

/**
 * Destroys the data associated with a tabId.
 * @param tabId The tab id's data to destory.
 */
function deleteDatawakeInfo(tabId) {
    if (hasDatawakeInfoForTab(tabId))
        delete datawakeInfoStorage[tabId];
}

/**
 * Checks to see if a tab has data associated with it.
 * @param tabId The tab id to check.
 * @returns {boolean} True if it has data in storage.
 */
function hasDatawakeInfoForTab(tabId){
    return datawakeInfoStorage.hasOwnProperty(tabId);
}