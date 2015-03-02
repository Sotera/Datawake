var simplePrefs = require("sdk/simple-prefs");
var addOnPrefs = simplePrefs.prefs;
var googleAuth = require("./google-auth");
var mockAuth = require("./mock");

var auth = {};

auth[2] = mockAuth;
auth[1] = googleAuth;

exports.getLoggedInUser = getLoggedInUser;
exports.signIn = signIn;
exports.signOut = signOut;
exports.authType = getAuthType;


function signIn(callback) {
    auth[addOnPrefs.useGoogleAuth].signIn(callback);
}

function signOut(callback) {
    auth[addOnPrefs.useGoogleAuth].signOut(callback);
}

function getLoggedInUser(callback) {
    auth[addOnPrefs.useGoogleAuth].getLoggedInUser(callback);
}

function getAuthType() {
    return addOnPrefs.useGoogleAuth;
}