define(['../util/util', '../util/guid', '../config/forensic_config', './testTrailsResponse'], function(util,guid,ForensicConfig,TEST_RESPONSE) {
	var USE_TEST_RESPONSE = ForensicConfig.useTestData;

	return {
		/**
		 * Ask the DataWake server for a list of all trails (domains, users, etc)
		 * @returns {*}
		 */
		get : function() {
			var d = new $.Deferred();

			var handleTrailsResponse = function(response) {
				var trails = [];
				var JSONResponse = JSON.parse(response);
				JSONResponse.forEach(function (trail) {
					if (util.hasProperties(trail)) {
						trail.id = guid.generate();
						trails.push(trail);
					}
				});
				return trails;
			};

			if (USE_TEST_RESPONSE) {
				return d.resolve(handleTrailsResponse(JSON.stringify(TEST_RESPONSE.response)));
			} else {
				$.get('/datawake/forensic/graphservice/trails')
					.then(function (response) {
						var trails = [];
						try {
							trails = handleTrailsResponse(response);
						} catch (err) {
							console.error('Server returned no trails!');
						}
						d.resolve(trails);
					})
					.fail(function (err) {
						d.reject(err);
					});
				return d.promise();
			}
		}
	};
});