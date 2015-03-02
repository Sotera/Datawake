define([], function() {
	return {
		/**
		 * Generates a random GUID
		 * @returns {string}
		 */
		generate : function() {
			var result = '';
			for (var i = 0; i < 32; i++) {
				if (i === 8 || i === 12 || i === 16 || i === 20) {
					result = result + '-';
				}
				result = result + Math.floor(Math.random() * 16).toString(16).toUpperCase();
			}

			return result;
		}
	};
});