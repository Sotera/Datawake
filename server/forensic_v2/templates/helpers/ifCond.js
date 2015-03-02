define('templates/helpers/ifCond', ['hbs/handlebars'], function ( Handlebars ) {

	// Allows us to use template conditionals like the following:
	//		{{#ifCond var1 '!==' undefined}}
	//			...
	//		{{#else}}
	//			...
	//		{{/ifCond}}
	function ifCond(v1, operator, v2, options) {
		switch (operator) {
			case '!=':
				return (v1 != v2) ? options.fn(this) : options.inverse(this);
			case '!==':
				return (v1 !== v2) ? options.fn(this) : options.inverse(this);
			case '==':
				return (v1 == v2) ? options.fn(this) : options.inverse(this);
			case '===':
				return (v1 === v2) ? options.fn(this) : options.inverse(this);
			case '<':
				return (v1 < v2) ? options.fn(this) : options.inverse(this);
			case '<=':
				return (v1 <= v2) ? options.fn(this) : options.inverse(this);
			case '>':
				return (v1 > v2) ? options.fn(this) : options.inverse(this);
			case '>=':
				return (v1 >= v2) ? options.fn(this) : options.inverse(this);
			case '&&':
				return (v1 && v2) ? options.fn(this) : options.inverse(this);
			case '||':
				return (v1 || v2) ? options.fn(this) : options.inverse(this);
			default:
				return options.inverse(this);
		}
	}

	Handlebars.registerHelper( 'ifCond', ifCond );
	return ifCond;
});
