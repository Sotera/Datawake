define(['hbs!templates/about'], function(aboutTemplate) {

	function AboutView(element) {
		this._parent = element;
		this._canvas = null;
		this._initialize(element);
	}

	AboutView.prototype._initialize = function(element) {
		this._canvas = $(aboutTemplate());
		this._canvas.appendTo(element);
	};

	return AboutView;
});