

/* On document ready */
document.addEventListener("turbolinks:load", function() {

	/* Conversion des champs <select> en tags sélectionnables avec selectize.js */
	var options = {
		delimiter: ',',
		persist: false,
		createOnBlur: true,
		create: true,
		maxItems: 30,
		closeAfterSelect: true
	};
	// New item
	$('#selectize-tags').selectize(options);
	// New item (BD)
	$("#selectize-series").selectize(options);
	$("#selectize-auteurs").selectize(options);
	$('#selectize-rangement').selectize(options);
	

});