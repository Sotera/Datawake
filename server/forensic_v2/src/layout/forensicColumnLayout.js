define(['../util/util', '../config/forensic_config'],function(_,ForensicConfig) {

	var COLUMN_STYLE = new Object({
		fillStyle: '#efefef',
		strokeStyle : '#121212',
		lineWidth : 1,
		lineDash : [5,5]
	});
	var COLUMN_HEADER_TEXT = ['Browse Path','Extracted Content','Unexplored Pages'];

	var NODE_PADDING = 5;

	/**
	 *
	 * @constructor
	 */
	var ForensicColumnLayout = function(columnWidth) {
		GraphJS.Layout.apply(this);
		this._duration = ForensicConfig.layoutDuration;
		this._easing = ForensicConfig.layoutEasing;
		this._columnWidth = columnWidth;
		this._rowDividers = [];
		this._columnHeaders = [null,null,null];
	};

	ForensicColumnLayout.prototype = GraphJS.Extend(ForensicColumnLayout, GraphJS.Layout.prototype, {
		/**
		 * Calculates the height of a laid-out array of nodes
		 * @param nodeList - an array of node objects
		 * @returns {Height} of column in pixels
		 * @private
		 */
		getGridCellHeight : function(nodeList) {
			var height = 0;
			if (nodeList) {
				for (var i = 0; i < nodeList.length; i++) {
					height+= (2*nodeList[i].radius) + NODE_PADDING;
				}
			}
			return height;
		},

		prerender : function() {
			var nodes = this.nodes();

			this._rowDividers = [];

			var renderObjects = [];
			if (!nodes || nodes.length === 0) {
				return renderObjects;
			}

			// Get the total number of rows
			var maxRows = 0;
			nodes.forEach(function(node) {
				maxRows = Math.max(maxRows,node.row);
			});
			var rows = [];
			for (var i = 0; i <= maxRows; i++) {
				rows.push(i);
				this._rowDividers.push({});
			}

			var that = this;
			var totalBB = this.getBoundingBox(this._nodes);
			var maxWidth = totalBB.width;
			var minX = totalBB.x;
			rows.forEach(function(row) {
				var nodesInRow = nodes.filter(function(node) {
					if (node.row === row) {
						return true;
					} else {
						return false;
					}
				});
				var bb = that.getBoundingBox(nodesInRow);
				var backgroundObject = path.rect({
					x : minX,
					y : bb.y,
					width : maxWidth,
					height : bb.height,
					fillStyle : COLUMN_STYLE.fillStyle,
					strokeStyle : COLUMN_STYLE.strokeStyle,
					lineDash : COLUMN_STYLE.lineDash,
					lineWidth : COLUMN_STYLE.lineWidth,
					opacity : 0.3
				});
				renderObjects.push(backgroundObject);
				that._rowDividers[row] = backgroundObject;
			});

			return renderObjects;
		},

		postrender : function() {
			var columnCenters = [null,null,null];
			var renderObjects = [];
			if (!this._nodes || this._nodes.length === 0) {
				return renderObjects;
			}

			this._nodes.forEach(function(node) {
				columnCenters[node.col] = node.x;
			});

			// Add column headers
			var fontString = ForensicConfig.LABEL.HEADER_HEIGHT + 'px ' + ForensicConfig.LABEL.FONT_FAMILY;
			var fillStyle = ForensicConfig.LABEL.FILL_STYLE;
			var shadowColor = ForensicConfig.LABEL.SHADOW_COLOR;
			var shadowBlur = ForensicConfig.LABEL.SHADOW_BLUR;

			var that = this;
			columnCenters.forEach(function(xLocation,index) {
				var headerSpec = {
					x : xLocation,
					y : 50,
					font: fontString,
					fillStyle: fillStyle,
					shadowColor : shadowColor,
					shadowBlur : shadowBlur,
					text : COLUMN_HEADER_TEXT[index],
					textAlign : 'center'
				};

				var textHeaderObject = path.text(headerSpec);
				that._columnHeaders[index] = textHeaderObject;
				renderObjects.push(textHeaderObject);
			});
			return renderObjects;
		},

		postrenderUpdate : function(minx,miny,maxx,maxy) {

			// Get the column centers
			var columnCenters = [null,null,null];
			var allSet = function() {
				var ret = true;
				columnCenters.forEach(function(c) {
					ret &= (c!==null);
				});
				return ret;
			};
			for (var i = 0; i < this._nodes.length && !allSet(); i++) {
				var node = this._nodes[i];
				if (columnCenters[node.col] === null) {
					columnCenters[node.col] = node.x;
				}
			}

			var bb = this.getBoundingBox(this._nodes);

			this._columnHeaders.forEach(function(textObject,i) {
				if (columnCenters[i]) {
					textObject.x = columnCenters[i];
					textObject.y = bb.y - 40;
				} else {
					textObject.x = -100000;
					textObject.y = -100000;
				}
			});
		},

		/**
		 * Perform a 3-column layout.   On the left is the browse path.   Center column
		 * contains any entities (email/phone) from the nodes in the browse path.  On the
		 * right column is a set of linked websites from the browse path.
		 * @param w - width of the canvas
		 * @param h - height of the canvas
		 * @returns {ForensicColumnLayout}
		 */
		_performLayout : function (w, h) {
			var x = 0;
			var y = 0;
			var nodeGridMap = {};
			var that = this;

			// Make a lookup of rows and columns for each grid cell
			var maxRow = -1;
			this._nodes.forEach(function(node) {
				var row = node.row;
				maxRow = Math.max(maxRow,row);
				var col = node.col;
				var key = row+','+col;

				var nodes = nodeGridMap[key];
				if (!nodes) {
					nodes = [];
				}
				nodes.push(node);
				nodeGridMap[key] = nodes;
			});

			// Layout each row one by one
			var top = NODE_PADDING;
			for (var i = 0; i <= maxRow; i++) {
				var columns = [nodeGridMap[i+',0']||[],nodeGridMap[i+',1']||[],nodeGridMap[i+',2']||[]];
				var cellHeights = [this.getGridCellHeight(columns[0]),this.getGridCellHeight(columns[1]),this.getGridCellHeight(columns[2])];
				var rowHeight = Math.max.apply(Math,cellHeights);

				// layout each column
				for (var j = 0; j < columns.length; j++) {
					var cellHeight = cellHeights[j];
					var cellTop = top + ((rowHeight - cellHeight) / 2.0);
					for (var k = 0; k < columns[j].length; k++) {
						var node = columns[j][k];
						x = that._columnWidth * (j+0.5);
						y = cellTop + node.radius + (node.lineWidth || 0);
						this._setNodePosition(node, x, y);
						this._positionedObjects++;
						cellTop += (2*node.radius) + NODE_PADDING;
					}
				}
				top += rowHeight;
			}
			this._renderHeight = top;


			// Animate backgrounds
			var maxRows = 0;
			this._nodes.forEach(function(node) {
				maxRows = Math.max(maxRows,node.row);
			});
			var rows = [];
			for (i = 0; i <= maxRows; i++) {
				rows.push(i);
			}

			var totalBB = this.getBoundingBox(this._nodes);
			var maxWidth = totalBB.width;
			var minX = totalBB.x;
			rows.forEach(function(row) {
				var nodesInRow = that._nodes.filter(function(node) {
					if (node.row === row) {
						return true;
					} else {
						return false;
					}
				});
				var bb = that.getBoundingBox(nodesInRow);
				var backgroundObject = that._rowDividers[row];
				backgroundObject.tweenAttr({
					x : minX,
					y : bb.y,
					width : maxWidth,
					height : bb.height
				},{
					duration : that._duration,
					easing : that._easing
				});

			});

			return false;
		},

		/**
		 * Browse path nodes should have the label to the left, entities to the right
		 * @param node
		 * @returns {{x: *, y: (finalY|*|node.y), textAlign: string}}
		 */
		layoutLabel : function(node) {
			var xOffset =  node.radius + (node.lineWidth || 0) + 5;
			var textAlign = 'start';
			if (node.type === 'browse_path') {
				xOffset*=-1;
				textAlign = 'end';
			}
			return {
				x : (node.finalX || node.x) + xOffset,
				y : (node.finalY || node.y),
				textAlign : textAlign
			};
		}
	});
	return ForensicColumnLayout;
});