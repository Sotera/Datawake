// jshint ignore: start
require.config({
	paths: {
		hbs: 'extern/hbs',
		templates: '../templates'
	},
	hbs: { // optional
		helpers: true,            // default: true
		i18n: false,              // default: false
		templateExtension: 'hbs', // default: 'hbs'
		partialsUrl: ''           // default: ''
	}
});