var addon = self;

function scrapePage() {
    try {
        var pageContents = {
            html: encodeURIComponent($('body').html())
        };
        console.log("Emitting page contents....");
        addon.port.emit("contents", pageContents);
    }
    catch (e) {
        console.error("Unable to Scrape Page: " + e);
    }
}



addon.port.on("loadToolTips", function (urls) {
    try {
        var $ = document; // shortcut
        for (var index in urls) {
            var cssId = 'myCss' + index;  // you could encode the css path itself to generate id..
            if (!$.getElementById(cssId)) {
                var head = $.getElementsByTagName('head')[0];
                var link = $.createElement('link');
                link.id = cssId;
                link.rel = 'stylesheet';
                link.type = 'text/css';
                link.href = urls[index];
                link.media = 'all';
                head.appendChild(link);
            }
        }
    }
    catch (e) {
        console.error("Do not have access to the document.");
    }
});

addon.port.on("removeSelections", function(className){
    console.log("removing hightlight for class: "+className)
    $("body").removeHighlight(className);
});


addon.port.on("highlight", function (selectionObject) {
    $.each(selectionObject, function(index, item){
        console.log("highlighting selection: "+item.selection)
        $('body').highlight(item.selection, "selections");
    });
});

addon.port.on("highlightTrailEntities", function(trailEntities){
    console.log("highlightTrailEntities")
    console.log(trailEntities)
    $.each(trailEntities, function(index, entity){
        console.log(index)
        console.log(entity)
        $("body").highlight(entity, "trailentities");
    });
});

addon.port.on("promptForFeedback", function(obj){
    var extractedValue = prompt("What should have been extracted?", obj.raw_text);
    var type = prompt("What type of entity is this? (phone, email, etc)");
    var response = {};
    response.type = type;
    response.value = extractedValue;
    addon.port.emit("feedback", response);
});

addon.port.on("highlightWithToolTips", function (helperObject) {
    var entities = helperObject.entities;
    var externalLinks = helperObject.links;
    console.log("highlightWithToolTips")
    console.log(helperObject)
    var i = 0;
    $.each(entities, function (type, values) {
        for (index in values){
            i = i + 1
            var value = values[index]
            console.log("looking to highlight value: "+value)
            try{
                $('body').highlight(value, 'datawake-highlight-' + i);
                if (externalLinks.length > 0) {
                    var content = '<div> <h4>' + type + ":" + value + '</h4>';
                    for (var j in externalLinks) {
                        var linkObj = externalLinks[j];
                        var link = linkObj.link;
                        link = link.replace("$ATTR", encodeURI(type));
                        link = link.replace("$VALUE", encodeURI(value));
                        content = content + '<a href="' + link + '" target="_blank">' + linkObj.display + '</a><br>'
                    }
                    content = content + '</div>';
                    $('.datawake-highlight-' + i).tooltipster({
                        content: $(content),
                        animation: 'fade',
                        interactive: true,
                        delapy: 200,
                        theme: 'tooltipster-noir',
                        trigger: 'hover'
                    });
                }
                else {
                    $('.datawake-highlight-' + i).tooltipster({
                        content: $('<div>' +
                                '<h4>' + type + ":" + value + '</h4>' +
                                'no external tools available' +
                                '</div>'
                        ),
                        animation: 'fade',
                        interactive: true,
                        delapy: 200,
                        theme: 'tooltipster-noir',
                        trigger: 'hover'
                    });
                }
            }
            catch(err){
                console.log(err)
            }
        }
    })
});


$(document).ready(function () {
    addon.port.emit("getToolTips");
    $(window).on('hashchange', scrapePage);
    scrapePage();
});
