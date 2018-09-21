
/* Instantiation de selectize sur un champ <select> 
   et ajout des elements listés dans data-selected comme valeurs prédéfinies */
function create_selectize(id) {

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
	    }
	};
	
	console.log(id);
	var j = $("#"+id);
	if (j.length) {
		

		$i = j.selectize(default_options);
		var selectize = $i[0].selectize;

		h = j.data("tag-list").map( function(current) {
			return {name: current}
		});
		selectize.addOption(h);
		

		/* Ajout des tags déja existants dans la liste jQuery.extend(*/
	/*	var data = j.data("selected");
		console.log(data);
		if (data.length > 0) {
			selectize = j[0].selectize;
			$.each( data.split(","), function(index, value) {
				console.log("ajout : "+value);
				selectize.addItem(value);
			});
		} */
	}
}


/* On document ready */
document.addEventListener("turbolinks:load", function() {

	// New item
	create_selectize("tag_names");
	// New item (BD)
	//create_selectize("select-series");
	//create_selectize("select-auteurs");
	//create_selectize("select-rangement");

});