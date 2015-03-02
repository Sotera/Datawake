define([], function() {
	return {

		/**
		 * Checks if an object has any properties
		 * @param obj
		 * @returns {boolean} - true if object has a property of it's own, false otherwise
		 */
		hasProperties : function(obj) {
			for (var key in obj) {
				if (obj.hasOwnProperty(key)) {
					return true;
				}
			}
			return false;
		},

		/**
		 * Display a modal overlay with a loader
		 * @private
		 */
		showLoader : function(message) {
			var overlay = $('<div/>')
				.attr('id','ajax_loader_overlay')
				.width(window.innerWidth)
				.height(window.innerHeight)
				.addClass('ajax_loader_overlay')
				.appendTo($(document.body));

			var container = $('<div/>')
				.addClass('ajax_loader_image')
				.appendTo(overlay);

			var img = $('<img/>')
				.attr('src','./img/ajax_loader.gif')
				.addClass('ajax_loader_img')
				.appendTo(container);

			if (message) {
				var msg = $('<div/>')
					.addClass('ajax_loader_text')
					.html(message);
					//.appendTo(container);  // todo: fix
			}

			var imgDim = parseInt(container.css('margin-left').replace('px',''))*-2;
			img.attr('width',imgDim);
			img.attr('height',imgDim);

			$(window).resize(function() {
				overlay.width(window.innerWidth).height(window.innerHeight).css('top','0px');

			});
		},

		/**
		 * Hide modal loader overlay
		 * @private
		 */
		hideLoader : function() {
			$('#ajax_loader_overlay').remove();
		},

		lerp : function(a,b,t) {
			return a + (t * (b-a));
		},

		clamp : function(val,min,max) {
			if (val < min) {
				return min;
			} else if (val > max) {
				return max;
			} else {
				return val;
			}
		}
	};
});