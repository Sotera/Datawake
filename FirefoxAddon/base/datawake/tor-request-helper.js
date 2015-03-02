var {Cc, Ci,Cu, Cr, components} = require("chrome");
var { atob, btoa } = Cu.import("resource://gre/modules/Services.jsm", {});
exports.DatawakeHTTPHelper = DatawakeHTTPHelper;

function DatawakeHTTPHelper() {
    this.wrappedJSObject = this;
    this.handlers = [];
}


DatawakeHTTPHelper.proxyProtocolService = Cc["@mozilla.org/network/protocol-proxy-service;1"].getService(Ci.nsIProtocolProxyService);
DatawakeHTTPHelper.ioService = Cc["@mozilla.org/network/io-service;1"].getService(Ci.nsIIOService);
DatawakeHTTPHelper.httpProtocolHandler = DatawakeHTTPHelper.ioService.getProtocolHandler("http").QueryInterface(Ci.nsIHttpProtocolHandler);

DatawakeHTTPHelper.buildProxyInfo = function (spec) {
    var flags = Ci.nsIProxyInfo.TRANSPARENT_PROXY_RESOLVES_HOST;
    if (spec.type === "http") {
        return DatawakeHTTPHelper.proxyProtocolService.newProxyInfo("http", spec.host, spec.port, flags, 0xffffffff, null);
    }
    return null;
};


DatawakeHTTPHelper.LocalConnectionHandler = function (callback) {
    this.callback = callback;
    this.channel = null;
    this.listener = null;
};

DatawakeHTTPHelper.LocalConnectionHandler.prototype = {

    makeRequest: function (req) {
        if (!this.requestOk(req)) {
            this.returnResponse({"error": "request failed validation"});
            return;
        }

        var proxyInfo = DatawakeHTTPHelper.buildProxyInfo(req.proxy);
        if (proxyInfo === null) {
            this.returnResponse({"error": "can't create nsIProxyInfo from " + JSON.stringify(req.proxy)});
            return;
        }

        // Construct an HTTP channel with the given nsIProxyInfo.
        // https://developer.mozilla.org/en-US/docs/XPCOM_Interface_Reference/nsIHttpChannel
        var uri;
        if (req.content) {
            var url = req.url+"?"
            for (param in req.content){
                url = url + param + "="+req.content[param]+"&"
            }
            url = url.substring(0,url.length-1)
            uri = DatawakeHTTPHelper.ioService.newURI(url,null,null)
        }
        else{
            uri = DatawakeHTTPHelper.ioService.newURI(req.url, null, null);
        }
        this.channel = DatawakeHTTPHelper.httpProtocolHandler.newProxiedChannel(uri, proxyInfo, 0, null)
            .QueryInterface(Ci.nsIHttpChannel);
        if (req.header !== undefined) {
            for (var key in req.header) {
                this.channel.setRequestHeader(key, req.header[key], false);
            }
        }
        if (req.body !== undefined) {
            var body = req.body;
            // Had to convert to UTF-8 Stream instead of string
            // https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XPCOM/Reference/Interface/nsIScriptableUnicodeConverter
            var converter = Cc["@mozilla.org/intl/scriptableunicodeconverter"]
                .createInstance(Ci.nsIScriptableUnicodeConverter);
            converter.charset = "UTF-8";
            var inputStream = converter.convertToInputStream(body);
            var uploadChannel = this.channel.QueryInterface(Ci.nsIUploadChannel);
            uploadChannel.setUploadStream(inputStream, "application/json", body.length);
        }
        // https://developer.mozilla.org/en-US/docs/XPCOM_Interface_Reference/nsIUploadChannel
        // says we must set requestMethod after calling setUploadStream.
        this.channel.requestMethod = req.method;
        this.channel.redirectionLimit = 0;

        this.listener = new DatawakeHTTPHelper.HttpStreamListener(this.returnResponse.bind(this));
        this.channel.asyncOpen(this.listener, this.channel);
    },

    returnResponse: function (resp) {
        this.callback(resp);
    },
    requestOk: function (req) {
        if (req.method === undefined) {
            console.error("req missing \"method\".\n");
            return false;
        }
        if (req.url === undefined) {
            console.error("req missing \"url\".\n");
            return false;
        }
        if (req.method !== "POST" && req.method !== "GET") {
            console.error("req.method is " + JSON.stringify(req.method) + ", not \"POST or GET\".\n");
            return false;
        }
        if (!(req.url.startsWith("http://") || req.url.startsWith("https://"))) {
            console.error("req.url doesn't start with \"http://\" or \"https://\".\n");
            return false;
        }

        return true;
    }
};
DatawakeHTTPHelper.lookupStatus = function (status) {
    for (var name in Cr) {
        if (Cr[name] === status)
            return name;
    }
    return null;
};
DatawakeHTTPHelper.HttpStreamListener = function (callback) {
    this.callback = callback;
    this.body = [];
    this.length = 0;
};
// https://developer.mozilla.org/en-US/docs/Creating_Sandboxed_HTTP_Connections
DatawakeHTTPHelper.HttpStreamListener.prototype = {
    // https://developer.mozilla.org/en-US/docs/XPCOM_Interface_Reference/nsIRequestObserver
    onStartRequest: function (req, context) {
    },

    onStopRequest: function (req, context, status) {
        try {
            var resp = {
                status: context.responseStatus
            };
            if (components.isSuccessCode(status)) {
                resp.body = this.body.join(" ");
            } else {
                var err = DatawakeHTTPHelper.lookupStatus(status);
                if (err !== null)
                    resp.error = err;
                else
                    resp.error = "error " + String(status);
            }
            this.callback(resp);

        } catch(e){
            console.log(e.message);
            console.log(e.stack);
            console.error("Context Closed");
        }
    },

    // https://developer.mozilla.org/en-US/docs/XPCOM_Interface_Reference/nsIStreamListener
    onDataAvailable: function (request, context, stream, sourceOffset, length) {
        if (this.length + length > 1000000) {
            request.cancel(Cr.NS_ERROR_ILLEGAL_VALUE);
            return;
        }
        this.length += length;
        var input = Cc["@mozilla.org/binaryinputstream;1"]
            .createInstance(Ci.nsIBinaryInputStream);
        input.setInputStream(stream);
        this.body.push(String.fromCharCode.apply(null, input.readByteArray(length)));
    }
};