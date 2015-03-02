var Request = require("sdk/request").Request;
var requestWrapper = require("./request-wrapper");

//exports.post = postRequest;
//exports.get = getRequest;


exports.post = proxyPost;
exports.get = proxyGet;
exports.postCode = postCode;
exports.delete = deleteRequest;

/**
 * Posts a json object to the server.
 * @param url The post url.
 * @param post_data The json data to post.
 * @param callback Response callback.
 */
function postRequest(url, post_data, callback) {
    var postObj = Request({
        url: url,
        onComplete: callback,
        content: post_data,
        contentType: "application/json"
    });
    postObj.post();
}

/**
 * Does a GET Request against a url.
 * @param url The url to request.
 * @param callback Response callback.
 */
function getRequest(url, callback,params) {
    var getObject = Request({
        url: url,
        contentType: "application/json",
        onComplete: callback
    });
    if (params){
        getObject.content = params
    }
    getObject.get();
}

function deleteRequest(url, callback) {
    var deleteObject = Request({
        url: url,
        contentType: "application/json",
        onComplete: callback
    });
    deleteObject.delete();
}


function postCode(url, svc, callback) {
    var data = {};
    data.code = svc.token;
    data.client_id = svc.consumerKey;
    data.client_secret = svc.consumerSecret;
    data.redirect_uri = "http://localhost";
    data.grant_type = "authorization_code";
    var postObj = Request({
        url: url,
        onComplete: callback,
        content: data
    });
    postObj.post();
}

function proxyPost(url, post_data, callback) {
    requestWrapper.postRequest(url, post_data, function (resp) {
        if (resp.status === 200) {
            var response = {};
            response.json = JSON.parse(resp.body);
            response.status = resp.status;
            callback(response);
        } else {
            console.error("POST: There is an error on the server side.");
            console.error(resp.error);
            console.error(resp.body);
            callback(resp);
        }
    })
}

function proxyGet(url, callback,params) {
    requestWrapper.getRequest(url, function (resp) {
        var response = {};
        if (resp.status === 200) {
            response.status = resp.status;
            response.json = JSON.parse(resp.body);
            callback(response);
        } else {
            console.error("GET: There is an error on the server side.");
            console.error(resp.error);
            console.error(resp.body);
            callback(resp);
        }

    },params);
}