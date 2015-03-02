var DatawakeHTTPHelper = require("./tor-request-helper").DatawakeHTTPHelper;
var simplePrefs = require("sdk/simple-prefs");
var addOnPrefs = simplePrefs.prefs;

exports.getRequest = getRequest;
exports.postRequest = postRequest;

function postRequest(url, post_data, callback) {
    var request = new DatawakeHTTPHelper.LocalConnectionHandler(callback);
    var req = {};
    req.url = url;
    req.method = "POST";
    req.body = post_data;
    req.proxy = {};
    req.proxy.type = "http";
    req.proxy.host = addOnPrefs.proxyHost;
    req.proxy.port = addOnPrefs.proxyPort;
    request.makeRequest(req);
}

function getRequest(url, callback,params) {
    var request = new DatawakeHTTPHelper.LocalConnectionHandler(callback);
    var req = {};
    req.url = url;
    req.method = "GET";
    req.proxy = {};
    req.proxy.type = "http";
    req.proxy.host = addOnPrefs.proxyHost;
    req.proxy.port = addOnPrefs.proxyPort;
    if(params){
        req.content = params
    }
    request.makeRequest(req);
}