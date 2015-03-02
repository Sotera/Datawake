var addOnPrefs = require("sdk/simple-prefs").prefs;

exports.preferencesAreValid = preferencesAreValid;


function preferencesAreValid() {
    addOnPrefs.datawakeDeploymentUrl = addOnPrefs.datawakeDeploymentUrl.trim();
    addOnPrefs.googleClientId = addOnPrefs.googleClientId.trim();
    addOnPrefs.googleClientSecret = addOnPrefs.googleClientSecret.trim();
    addOnPrefs.proxyHost = addOnPrefs.proxyHost.trim();
    return validateAuth() && validateProxy() && validateDeploymentUrl();
}

function isNullOrEmpty(s) {
    return s === "" || s === void(0);
}

function validateAuth() {
    return (addOnPrefs.useGoogleAuth === 1) ? !isNullOrEmpty(addOnPrefs.googleClientId) && !isNullOrEmpty(addOnPrefs.googleClientSecret) : true;
}

function validateProxy() {
    return !isNullOrEmpty(addOnPrefs.proxyHost)
}

function validateDeploymentUrl() {
    return !isNullOrEmpty(addOnPrefs.datawakeDeploymentUrl);
}