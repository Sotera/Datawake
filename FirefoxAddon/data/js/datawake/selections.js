self.on("click", function (node, contextItemDataProperty) {
    var messageWrapper = {};
    if (contextItemDataProperty == "selection" || contextItemDataProperty == "feedback" || contextItemDataProperty == "add-trail-entity") {
        messageWrapper.text = window.getSelection().toString();
    }
    messageWrapper.intent = contextItemDataProperty;
    self.postMessage(messageWrapper);
});