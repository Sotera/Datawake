var tabs = require("sdk/tabs");
var self = require("sdk/self");
var data = self.data;
var addOnPrefs = require("sdk/simple-prefs").prefs;

var requestHelper = require("./request-helper");

exports.getLoggedInUser = getLoggedInUser;
exports.signIn = signIn;
exports.signOut = signOut;

var MOCK_TOKEN = "123456";
var loggedInUser;

var MOCK_USER = {
    "kind": "plus#person",
    "etag": "",
    "gender": "none",
    "emails": [
        {
            "value": "john.doe@gmail.com",
            "type": "account"
        }
    ],
    "objectType": "person",
    "id": "123456",
    "displayName": "John Doe",
    "name": {
        "familyName": "Doe",
        "givenName": "John"
    },
    "url": "",
    "image": {
        "url": "",
        "isDefault": true
    },
    "isPlusUser": true,
    "language": "en",
    "ageRange": {
        "min": 21
    },
    "circledByCount": 0,
    "verified": false
};

/**
 * Uses the MOCK_AUTH token to login.
 * @param callback Request response callback.
 */
function mockLogin(callback) {
    console.debug("I HAVE AN AUTH TOKEN. Ready to start a server session " + MOCK_TOKEN);
    var post_data = JSON.stringify({token: MOCK_TOKEN});
    requestHelper.post(addOnPrefs.datawakeDeploymentUrl + "/session", post_data, callback);
}

/**
 * Gets the current logged in user.
 * @param callback Request callback.
 */
function getLoggedInUser(callback) {
    if (loggedInUser == undefined || loggedInUser == null) {
        requestHelper.get(addOnPrefs.datawakeDeploymentUrl + "/session", callback);
    } else {
        callback(loggedInUser);
    }
}

/**
 * Callback after a user has been logged in.
 * @param response The response object returned from the server.
 */
function userLoginComplete(response) {
    loggedInUser = response;
    console.debug("datawake-plugin-server session established: " + loggedInUser.json.email);
}

/**
 * Triggers Mock Authentication.
 */
function mockAuth(callback) {
    mockLogin(callback);
}

function signIn(callback) {
    mockAuth(callback);
}

function signOut(callback) {
    requestHelper.delete(addOnPrefs.datawakeDeploymentUrl + "/session", callback);
}