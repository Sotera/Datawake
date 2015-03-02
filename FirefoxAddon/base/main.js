//Datawake Components
require("sdk/preferences/service").set("extensions.sdk.console.logLevel", "info");
var datawakeController = require("./datawake/controller");
datawakeController.loadDatawake()