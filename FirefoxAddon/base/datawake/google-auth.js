var OAuthConsumer = require("oauthorizer/oauthconsumer").OAuthConsumer;
var requestHelper = require("./request-helper");
var addOnPrefs = require("sdk/simple-prefs").prefs;

exports.signIn = interactiveSignIn;
exports.signOut = signOut;
exports.getLoggedInUser = getLoggedInUser;

function interactiveSignIn(callback) {
    var calls = {
        userAuthorizationURL: "https://accounts.google.com/o/oauth2/auth"
    };
    var p = OAuthConsumer.makeProvider('google-oauth2', 'Google',
        addOnPrefs.googleClientId, addOnPrefs.googleClientSecret,
        "http://localhost", calls);
    p.version = "2.0";
    p.tokenRx = /\?code=([^&]*)/gi;

    p.requestParams = {
        'response_type': 'code',
        'xoauth_displayname': "DataWake Firefox/Tor Extension",
        'scope': "https://www.googleapis.com/auth/plus.login email",
        'access_type': 'online'
    };


    function tokenCallback(svc) {
        //Google Specific Token Request.
        requestHelper.postCode("https://accounts.google.com/o/oauth2/token", svc, function (response) {
            postUserLogin(response.json["access_token"], callback);
        });
    }

    var handler = OAuthConsumer.getAuthorizer(p, tokenCallback);
    try {
        handler.getUserAuthorization();
    } catch (e) {
        console.error("The Google parameters are incorrect.");
        console.error(e);
    }
}

function postUserLogin(token, callback) {
    var post_data = JSON.stringify({token: token});
    requestHelper.post(addOnPrefs.datawakeDeploymentUrl + "/session", post_data, callback);
}

function signOut(callback) {
    requestHelper.delete(addOnPrefs.datawakeDeploymentUrl + "/session", callback);
}

function getLoggedInUser(callback) {
    requestHelper.get(addOnPrefs.datawakeDeploymentUrl + "/session", callback);
}

