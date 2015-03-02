define([], function() {
	var topics = {};
	return {
		/**
		 * Subscribe to a message channel
		 * @param topic - the channel to subscribe to
		 * @param listener - the callback function
		 * @param self - option parameter.   Will be 'this' in the callback
		 * @returns {{remove: Function}}
		 */
		subscribe: function(topic, listener, self) {
			// Create the topic's object if not yet created
			if(!topics[topic]) {
				topics[topic] = { queue: [] };
			}

			// Add the listener to queue
			var index = topics[topic].queue.push({
					func : listener,
					self : self
				}) -1;

			// Provide handle back for removal of topic
			return {
				remove: function() {
					delete topics[topic].queue[index];
				}
			};
		},

		/**
		 * Publishes a message on the given channel
		 * @param topic - the message channel publishing to
		 * @param info - data object passed to the handler
		 */
		publish: function(topic, info) {
			// If the topic doesn't exist, or there's no listeners in queue, just leave
			if(!topics[topic] || !topics[topic].queue.length) {
				return;
			}

			// Cycle through topics queue, fire!
			var items = topics[topic].queue;
			items.forEach(function(item) {
				if (item.self) {
					item.func.call(item.self, info || {});
				} else {
					item.func(info || {});
				}
			});
		},

		/**
		 * An enum of topics that can be pub/subbed
		 */
		topics: {
			'TRAIL_CHANGE' 	: 'trail_change',
			'DATE_RANGE_CHANGE' : 'date_range_change',
			'REFRESH' 		: 'refresh',
			'FIT'			: 'fit',
			'TOGGLE_LEGEND' : 'toggle_legend',
			'TOGGLE_LABELS' : 'toggle_labels',
			'SHOW_ABOUT'	: 'show_about',
			'TRIM'			: 'trim'
		}
	};
});