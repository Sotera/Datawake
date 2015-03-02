define(['../util/util', '../util/guid', './testGraphResponse', '../config/forensic_config', '../util/events'], function(util,guid,TEST_RESPONSE,ForensicConfig,Events) {
	var USE_TEST_RESPONSE = ForensicConfig.useTestData;

	var startDate = null;
	var endDate = null;
	Events.subscribe(Events.topics.DATE_RANGE_CHANGE, function(data) {
		startDate = data.start.unix();
		endDate = data.end.unix();
	});

	return {

		/**
		 * Ask the DataWake server for the info on the specified trail.
		 * @param trail
		 * @returns {*}
		 */
		get : function(trail) {
			var requestData = {
				name : 'OculusForensicRequest',
				startdate :  startDate,
				enddate :	endDate
			};
			requestData.users = trail.users;
			requestData.domain = trail.domain;
			requestData.trail = trail.trail;

			if (USE_TEST_RESPONSE) {
				var d = new $.Deferred();
				return d.resolve(TEST_RESPONSE);
			} else {
				return $.ajax({
					type: 'POST',
					url: '/datawake/forensic/graphservice/get',
					data: JSON.stringify(requestData),
					contentType: 'application/json',
					dataType: 'json'
				});
			}
		}
	};
});