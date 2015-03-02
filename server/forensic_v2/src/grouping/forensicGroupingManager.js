define(['../util/guid','../util/util','../config/forensic_config'], function(guid,_, ForensicConfig) {

	/**
	 *
	 * @constructor
	 */
	var ForensicGroupingManager = function() {
		GraphJS.GroupingManager.apply(this);
		this._nodeIndexToLinks = {};
	};
	
	ForensicGroupingManager.prototype = GraphJS.Extend(ForensicGroupingManager.prototype, GraphJS.GroupingManager.prototype, {

		/**
		 * Remove duplicate entities from aggregate list.
		 * @param aggregateLists - a list of row aggregates of a common type (email, website, phone)
		 * @returns {Array} - each subarray will be a set of entities based on value
		 * @private
		 */
		_removeDuplicatesFromList : function(aggregateLists) {
			var condensedList = [];
			for (var i = 0; i < aggregateLists.length; i++) {
				condensedList.push(this._removeDuplicates(aggregateLists[i]));
			}
			return condensedList;
		},

		/**
		 * Given a list of entity nodes, remove any duplicate values and update links from them to the first
		 * node found with that value
		 * @param aggregate
		 * @returns {Array}
		 * @private
		 */
		_removeDuplicates : function(aggregate) {
			var valueMap = {};
			var that = this;
			aggregate.forEach(function(entity) {
				if (!valueMap[entity.value]) {
					valueMap[entity.value] = entity;
				} else {
					// update links to singleton
					var assocatedLinks = that._nodeIndexToLinks[entity.index];
					if (assocatedLinks) {
						assocatedLinks.forEach(function(link) {
							if (entity.index === link.source.index) {
								link.source = valueMap[entity.value];
							} else {
								link.target = valueMap[entity.value];
							}
						});
					}

				}
			});
			var condensed = [];
			for (var entityKey in valueMap) {
				if (valueMap.hasOwnProperty(entityKey)) {
					condensed.push(valueMap[entityKey]);
				}
			}
			return condensed;
		},

		/**
		 * Groups entityList by website domain.
		 * @param entityList
		 * @returns {{}} - a map of domain to a list of entities
		 * @private
		 */
		_clusterByDomain : function(entityList) {
			var domainMap = {};
			entityList.forEach(function(entity) {
				var entities = domainMap[entity.domain];
				if (!entities) {
					entities = [];
				}
				entities.push(entity);
				domainMap[entity.domain] = entities;
			});
			return domainMap;
		},

		/**
		 * Groups entityList by area code
		 * @param entityList - a list of phone entities
		 * @returns {{}} - a map from string to list of entities
		 * @private
		 */
		_clusterByAreaCode : function(entityList) {
			var areacodeMap = {};
			entityList.forEach(function(entity) {
				var areaCode = entity.value.substring(0,3);
				var entities = areacodeMap[areaCode];
				if (!entities) {
					entities = [];
				}
				entities.push(entity);
				areacodeMap[areaCode] = entities;
			});
			return areacodeMap;
		},

		/**
		 * Perform node aggregation for Datawake Forensic.   Group browse path by domain and entities by type.
		 * Phone entities are grouped by area code, email/websites by domain.  Removes any duplicate entities
		 * from the same group if they are linked to multuple browse path nodes/entities
		 * @private
		 */
		_aggregateNodes: function () {
			var nodeIndexToLinks = [];
			var nodeIndexToOutgoingLinks = [];
			this._links.forEach(function(link) {
				var srcIdx = link.source.index;
				var links = nodeIndexToLinks[srcIdx];
				if (!links) {
					links = [];
				}
				links.push(link);
				nodeIndexToLinks[srcIdx] = links;

				var outgoingLinks = nodeIndexToOutgoingLinks[srcIdx];
				if (!outgoingLinks) {
					outgoingLinks = [];
				}
				outgoingLinks.push(link);
				nodeIndexToOutgoingLinks[srcIdx] = links;

				var dstIdx = link.target.index;
				links = nodeIndexToLinks[dstIdx];
				if (!links) {
					links = [];
				}
				links.push(link);
				nodeIndexToLinks[dstIdx] = links;
			});
			this._nodeIndexToLinks = nodeIndexToLinks;



			// aggregate the browse path
			var lastAggregatedDomain = '';
			var browsePathAggregates = [];
			var browsePathNodes = this._nodes.filter(function (node) {
				return node.type === 'browse_path';
			});

			// Group nodes in the browse path that have the same top level domain
			browsePathNodes.forEach(function (node) {
				if (node.domain !== lastAggregatedDomain) {
					browsePathAggregates.push([node]);
					lastAggregatedDomain = node.domain;
				} else {
					browsePathAggregates[browsePathAggregates.length - 1].push(node);
				}
			});

			var groupEmails = [];
			var groupPhoneNumbers = [];
			var groupRelatedLinks = [];
			var that = this;
			browsePathAggregates.forEach(function (nodeGroup) {
				var phoneClusters = [];
				var emailClusters = [];
				var relatedLinkClusters = [];
				nodeGroup.forEach(function (groupedNode) {
					that._nodes.filter(function (node) {

						if (node.row === groupedNode.row) {
							switch (node.type) {
								case 'email':
									emailClusters.push(node);
									break;
								case 'website':
									relatedLinkClusters.push(node);
									break;
								case 'phone':
									phoneClusters.push(node);
									break;
							}

						}
					});
				});
				groupEmails.push(emailClusters);
				groupPhoneNumbers.push(phoneClusters);
				groupRelatedLinks.push(relatedLinkClusters);
			});

			groupEmails = this._removeDuplicatesFromList(groupEmails);
			groupPhoneNumbers = this._removeDuplicatesFromList(groupPhoneNumbers);
			groupRelatedLinks = this._removeDuplicatesFromList(groupRelatedLinks);


			var aggregatedNodes = [];
			for (var row = 0; row < browsePathAggregates.length; row++) {

				if (browsePathAggregates[row].length === 1) {
					browsePathAggregates[row][0].row = row;
					browsePathAggregates[row][0].col = 0;
					aggregatedNodes.push(browsePathAggregates[row][0]);
				} else {
					aggregatedNodes.push({
						x: 0,
						y: 0,
						index: guid.generate(),
						fillStyle: ForensicConfig.BROWSE_PATH_ENTITY.FILL_STYLE,
						standardFill: ForensicConfig.BROWSE_PATH_ENTITY.FILL_STYLE,
						highlightFill: ForensicConfig.HIGHLIGHT.FILL_STYLE,
						type: 'browse_path',
						strokeStyle: ForensicConfig.BROWSE_PATH_ENTITY.STROKE_STYLE,
						lineWidth: ForensicConfig.BROWSE_PATH_ENTITY.STROKE_WIDTH,
						labelText: browsePathAggregates[row][0].domain,
						children: browsePathAggregates[row],
						innerLabel: browsePathAggregates[row].length,
						innerLabelFillStyle : ForensicConfig.LABEL.INNER_FILL_STYLE,
						row: row,
						col: 0
					});
				}

				var clusteredEmails = this._clusterByDomain(groupEmails[row]);
				for (var domainKey in clusteredEmails) {
					if (clusteredEmails.hasOwnProperty(domainKey)) {
						if (clusteredEmails[domainKey].length === 1) {
							clusteredEmails[domainKey][0].row = row;
							clusteredEmails[domainKey][0].col = 1;
							aggregatedNodes.push(clusteredEmails[domainKey][0]);
						} else {
							aggregatedNodes.push({
								x: 0,
								y: 0,
								index: guid.generate(),
								fillStyle: ForensicConfig.EMAIL_ENTITY.FILL_STYLE,
								standardFill: ForensicConfig.EMAIL_ENTITY.FILL_STYLE,
								highlightFill: ForensicConfig.HIGHLIGHT.FILL_STYLE,
								lineWidth: ForensicConfig.EMAIL_ENTITY.STROKE_WIDTH,
								type: 'email',
								strokeStyle: ForensicConfig.EMAIL_ENTITY.STROKE_STYLE,
								labelText: domainKey,
								children: clusteredEmails[domainKey],
								innerLabel: clusteredEmails[domainKey].length,
								innerLabelFillStyle : ForensicConfig.LABEL.INNER_FILL_STYLE,
								row: row,
								col: 1
							});
						}
					}
				}

				// Split phone numbers into two groups.   One with outgoing links, and one without any
				var unlinkedPhoneNumbers = [];
				var linkedPhoneNumbers = [];
				groupPhoneNumbers[row].forEach(function(node) {
					if (!nodeIndexToOutgoingLinks[node.index] || nodeIndexToOutgoingLinks[node.index].length === 0) {
						unlinkedPhoneNumbers.push(node);
					} else {
						linkedPhoneNumbers.push(node);
					}
				});

				var clusteredPhoneNumbers = this._clusterByAreaCode(linkedPhoneNumbers);
				for (var areaCodeKey in clusteredPhoneNumbers) {
					if (clusteredPhoneNumbers.hasOwnProperty(areaCodeKey)) {
						if (clusteredPhoneNumbers[areaCodeKey].length === 1) {
							clusteredPhoneNumbers[areaCodeKey][0].row = row;
							clusteredPhoneNumbers[areaCodeKey][0].col = 1;
							aggregatedNodes.push(clusteredPhoneNumbers[areaCodeKey][0]);
						} else {
							aggregatedNodes.push({
								x: 0,
								y: 0,
								index: guid.generate(),
								fillStyle: ForensicConfig.PHONE_ENTITY.FILL_STYLE,
								standardFill: ForensicConfig.PHONE_ENTITY.FILL_STYLE,
								highlightFill: ForensicConfig.HIGHLIGHT.FILL_STYLE,
								lineWidth: ForensicConfig.PHONE_ENTITY.STROKE_WIDTH,
								type: 'phone',
								strokeStyle: ForensicConfig.PHONE_ENTITY.STROKE_STYLE,
								labelText: areaCodeKey,
								children: clusteredPhoneNumbers[areaCodeKey],
								innerLabel: clusteredPhoneNumbers[areaCodeKey].length,
								innerLabelFillStyle : ForensicConfig.LABEL.INNER_FILL_STYLE,
								row: row,
								col: 1
							});
						}
					}
				}

				// Add the unlinked phonenumbers group
				if (unlinkedPhoneNumbers.length === 1) {
					unlinkedPhoneNumbers[0].row = row;
					unlinkedPhoneNumbers[0].col = 1;
					aggregatedNodes.push(unlinkedPhoneNumbers[0]);
				} else if (unlinkedPhoneNumbers.length != 0) {
					aggregatedNodes.push({
						x : 0,
						y : 0,
						index: guid.generate(),
						fillStyle: ForensicConfig.PHONE_ENTITY.FILL_STYLE,
						standardFill: ForensicConfig.PHONE_ENTITY.FILL_STYLE,
						highlightFill: ForensicConfig.HIGHLIGHT.FILL_STYLE,
						lineWidth: ForensicConfig.PHONE_ENTITY.STROKE_WIDTH,
						type: 'phone',
						strokeStyle: ForensicConfig.PHONE_ENTITY.STROKE_STYLE,
						labelText: 'Others',
						children: unlinkedPhoneNumbers,
						innerLabel: unlinkedPhoneNumbers.length,
						innerLabelFillStyle : ForensicConfig.LABEL.INNER_FILL_STYLE,
						row: row,
						col: 1
					});
				}

				var clusteredRelatedLinks = this._clusterByDomain(groupRelatedLinks[row]);
				for (domainKey in clusteredRelatedLinks) {
					if (clusteredRelatedLinks.hasOwnProperty(domainKey)) {
						if (clusteredRelatedLinks[domainKey].length === 1) {
							clusteredRelatedLinks[domainKey][0].row = row;
							clusteredRelatedLinks[domainKey][0].col = 2;
							aggregatedNodes.push(clusteredRelatedLinks[domainKey][0]);
						} else {
							aggregatedNodes.push({
								x: 0,
								y: 0,
								index: guid.generate(),
								fillStyle: ForensicConfig.WEBSITE_ENTITY.FILL_STYLE,
								standardFill: ForensicConfig.WEBSITE_ENTITY.FILL_STYLE,
								highlightFill: ForensicConfig.HIGHLIGHT.FILL_STYLE,
								lineWidth: ForensicConfig.WEBSITE_ENTITY.STROKE_WIDTH,
								type: 'website',
								strokeStyle: ForensicConfig.WEBSITE_ENTITY.STROKE_STYLE,
								labelText: domainKey,
								children: clusteredRelatedLinks[domainKey],
								innerLabel: clusteredRelatedLinks[domainKey].length,
								innerLabelFillStyle : ForensicConfig.LABEL.INNER_FILL_STYLE,
								row: row,
								col: 2
							});
						}
					}
				}
			}

			// Get min/max group size to compute the radii
			var minAggregateSize = Number.MAX_VALUE;
			var maxAggregateSize = 0;
			aggregatedNodes.forEach(function(aggregate) {
				if (aggregate.children && aggregate.children.length > 0) {
					minAggregateSize = Math.min(minAggregateSize, aggregate.children.length);
					maxAggregateSize = Math.max(maxAggregateSize, aggregate.children.length);
				}
			});

			// Set the radius for each node
			aggregatedNodes.forEach(function(aggregate) {
				if (aggregate.children) {
					aggregate.radius = _.lerp(ForensicConfig.NODE_RADIUS.AGGREGATE_MIN, ForensicConfig.NODE_RADIUS.AGGREGATE_MAX, aggregate.children.length / maxAggregateSize);
				}
			});


			this._aggregatedNodes = aggregatedNodes;
		},

		/**
		 * Aggregate link specialization for Forensic.   Make sure we draw arrows between browse path nodes.
		 * @param sourceAggregate
		 * @param targetAggregate
		 * @returns {{source: *, target: *}}
		 * @private
		 */
		_createAggregateLink : function (sourceAggregate, targetAggregate, originalLinks, minLinkCount, maxLinkCount) {
			if (sourceAggregate.index === targetAggregate.index) {
				return;
			}
			var link = {
				source: sourceAggregate,
				target: targetAggregate,
				originalLinks : originalLinks
			};
			if (sourceAggregate.type === 'browse_path' && targetAggregate.type === 'browse_path') {
				link.type = ForensicConfig.BROWSE_PATH_LINK.LINE_TYPE;
				link.lineWidth = ForensicConfig.BROWSE_PATH_LINK.LINE_WIDTH;
				link.strokeStyle = ForensicConfig.BROWSE_PATH_LINK.STROKE_STYLE;
				link.standardStroke = link.strokeStyle;
				link.highlightStroke = link.strokeStyle;
			} else {
				link.type = ForensicConfig.ENTITY_LINK.LINE_TYPE;
				link.lineWidth = _.lerp(ForensicConfig.ENTITY_LINK.MIN_LINE_WIDTH, ForensicConfig.ENTITY_LINK.MAX_LINE_WIDTH, Math.floor(originalLinks.length / maxLinkCount));
				link.strokeStyle = ForensicConfig.ENTITY_LINK.STROKE_STYLE;
				link.standardStroke = link.strokeStyle;
				link.highlightStroke = ForensicConfig.HIGHLIGHT.STROKE_STYLE;
			}
			return link;
		},

		onAggregationComplete : function() {
			var degreeMap = {};
			var minDegree = Math.MAX_VALUE;
			var maxDegree = 0;
			this._aggregatedLinks.forEach(function(link) {
				var sourceDegree = degreeMap[link.source.index];
				if (!sourceDegree) {
					sourceDegree = 0;
				}
				sourceDegree += link.originalLinks.length;
				degreeMap[link.source.index] = sourceDegree;

				var targetDegree = degreeMap[link.target.index];
				if (!targetDegree) {
					targetDegree = 0;
				}
				targetDegree += link.originalLinks.length;
				degreeMap[link.target.index] = targetDegree;

				minDegree = Math.min(minDegree,targetDegree);
				minDegree = Math.min(minDegree,sourceDegree);

				maxDegree = Math.max(maxDegree,targetDegree);
				maxDegree = Math.max(maxDegree,sourceDegree);
			});


			this._aggregatedNodes.forEach(function(aggregate) {
				aggregate.radius = _.lerp(ForensicConfig.NODE_RADIUS.AGGREGATE_MIN, ForensicConfig.NODE_RADIUS.AGGREGATE_MAX, degreeMap[aggregate.index]/maxDegree);
			});
		},


		/**
		 * Ensure position/row/col are all set correctly for children when ungrouping
		 * @param aggregate
		 * @private
		 */
		_updateChildren : function (aggregate) {
			// Set all childrens position to that of their parent
			aggregate.children.forEach(function (child) {
				child.x = aggregate.x;
				child.y = aggregate.y;
				child.row = aggregate.row;
			});
		},

		getMinimizeIconPosition : function(boundingBox,ungroupedNodes) {
			var node = ungroupedNodes[0];
			if (node.type === 'browse_path') {
				return {
					x : boundingBox.x + boundingBox.width + 10,
					y : boundingBox.y - 20
				};
			} else {
				return {
					x: boundingBox.x - 30,
					y: boundingBox.y - 20
				};
			}
		}
	});
	return ForensicGroupingManager;
});