var preferences = require("./datawake/preference-validator");
var addOnPrefs = require("sdk/simple-prefs").prefs;
exports["test preferenceValidator ok"] = function (assert) {
    addOnPrefs.datawakeDeploymentUrl = "http://localhost:8088/datawake-plugin-server";
    addOnPrefs.proxyHost = "127.0.0.1";
    addOnPrefs.useGoogleAuth = 2;
    assert.ok(preferences.preferencesAreValid(), "Preferences valid works.");
};

exports["test preferenceValidator invalid"] = function (assert) {
    addOnPrefs.proxyHost = "";
    assert.ok(!preferences.preferencesAreValid(), "Preferences invalid works. No Proxy Host");
};
exports["test preferenceValidator invalid: No DeploymentUrl"] = function (assert) {
    addOnPrefs.datawakeDeploymentUrl = "";
    addOnPrefs.proxyHost = "127.0.0.1";
    assert.ok(!preferences.preferencesAreValid(), "Preferences invalid works.  No Deployment Url.");
};

exports["test google auth enabled"] = function(assert){
    addOnPrefs.datawakeDeploymentUrl = "http://localhost:8088/datawake-plugin-server";
    addOnPrefs.proxyHost = "127.0.0.1";
    addOnPrefs.useGoogleAuth = 1;
    addOnPrefs.googleClientId = "cliendId";
    addOnPrefs.googleClientSecret = "clientSecret";
    assert.ok(preferences.preferencesAreValid(), "Google Auth Validated.");
};


require("sdk/test").run(exports);