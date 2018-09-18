
/* Instantiation de selectize sur un champ <select> 
   et ajout des elements listés dans data-selected comme valeurs prédéfinies */
function create_selectize(select_id) {

	var default_options = {
		delimiter: ',',
		persist: false,
		maxItems: 30,
		createOnBlur: true,
		closeAfterSelect: true,
		valueField: 'name',
    	labelField: 'name',
    	searchField: ['name'],
    	render: {
    		/* item = dans le champ input text */
	        item: function(item, escape) {
	            return '<div>' +
	                '<span class="name">' + escape(item.name) + '</span>' +
	            '</div>';
	        },
	        /* option = dans la liste déroulante */
	        option: function(item, escape) {
	            return '<div>' +
	                '<span class="name">' + escape(item.name) + '</span>'  +
	            '</div>';
	        }
	    },
		create: function(input) {
            return { name  : input }
	    },
	};

	console.log(select_id);
	var j = $("#"+select_id);
	if (j.length) {
		var s = j.selectize(default_options);

		/* Ajout des tags déja existants dans la liste */
		var data = j.data("selected");
		console.log(data);
		if (data.length > 0) {
			selectize = j[0].selectize;
			$.each( data.split(","), function(index, value) {
				console.log("ajout : "+value);
				selectize.addItem(value);
			});
		}
	}
}


/* On document ready */
document.addEventListener("turbolinks:load", function() {

	// New item
	create_selectize("select-tags");
	// New item (BD)
	create_selectize("select-series");
	create_selectize("select-auteurs");
	create_selectize("select-rangement");

});