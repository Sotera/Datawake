var self = require("sdk/self");
var data = self.data;

exports.isValidUrl = isValidUrl;
exports.isOverrideUrl = isOverrideUrl;

var urlsToIgnore = ["about:blank", "about:newtab", "about:tor", "http://lakitu:8080/", "chrome:", "http://localhost", "https://sotweb.istresearch.com", "https://ocweb.istresearch.com", "datawake-tab-panel.html"];

/**
 * Checks to see if a url is in the set of links to ignore.
 * @param url Url to check.
 * @returns {boolean} True if it is valid.
 */
function isValidUrl(url) {
    for (var index in urlsToIgnore) {
        var currentUrl = urlsToIgnore[index];
        if (url.indexOf(currentUrl) >= 0) {
            return false;
        }
    }
    return true;
}

var overrideUrls = ["about:tor", "about:newtab", "about:blank"];
/**
 * Checks whether or not a tab needs to override the url with a custom page.
 * @param url Url to check.
 * @returns {boolean} True if it needs to be overridden.
 */
function isOverrideUrl(url) {
    return overrideUrls.indexOf(url) > 0;
}