define([],function() {

	var prettyPalette = ['#359135',
		'#475147',
		'#457145',
		'#0CB60C',
		'#00D400',
		'#B58F42',
		'#656159',
		'#8D7B56',
		'#E49D0F',
		'#FFAA00',
		'#5F3079',
		'#413C43',
		'#523C5E',
		'#681198',
		'#7804B8'];

	var module = {};

	module.randomNodes = function (maxRadius, num) {
		var nodes = [];
		for (var i = 0; i < num; i++) {
			var node = {
				x: 0,
				y: 0,
				radius: Math.floor(5 + (Math.random() * (maxRadius))),
				label: 'Index: ' + i,
				index: i,
				fillStyle: prettyPalette[Math.floor(prettyPalette.length * Math.random())]
			};
			nodes.push(node);
		}
		return nodes;
	};


	module.radialLinks = function (nodes, focusIdx) {
		var focusNode = nodes[focusIdx];
		var links = [];
		$.each(nodes, function () {
			if (this.index === focusIdx) {
				return;
			}
			links.push({
				source: focusNode,
				target: this,
				strokeStyle: '#ababab'
			});
		});
		return links;
	};
	return module;
});