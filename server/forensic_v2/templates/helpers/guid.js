define('templates/helpers/guid', ['hbs/handlebars','../../src/util/guid'], function ( Handlebars, guidModule ) {

	function guid() {
		return guidModule.generate();
	}

	Handlebars.registerHelper( 'guid', guid );
	return guid;
});