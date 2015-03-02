define(['hbs!templates/tooltip'], function(tooltipTemplate) {


    function TooltipView(element,spec) {
        this._parent = element;
        this._canvas = null;
        this._initialize(element,spec);
    }

    TooltipView.prototype._initialize = function(element,spec) {

    };

    TooltipView.prototype.show = function(spec) {
        if (this._canvas) {
            this._canvas.remove();
        }
        this._canvas = $(tooltipTemplate({
            labels : spec.labels
        }));
        this._parent.append(this._canvas);
        if (spec.orientation === 'NW') {
            this._canvas.offset({
                top : spec.y -10,
                left : spec.x + 10
            });
        } else {
            this._canvas.offset({
                top : spec.y + 10,
                left : spec.x - this._canvas.width() - 10
            });
        }
    };


    TooltipView.prototype.hide = function(delay) {
        var that = this;
        var _doHide = function() {
            var c = that._canvas;
            c.animate({
                opacity : 0
            }, function() {
                c.remove();
            });
        };

        setTimeout(function() {
            _doHide();
        },delay||1);
    };

    return TooltipView;
});