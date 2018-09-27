
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
	            return '<div class="collector-tag collector-tag-fitler"> ' +
	                '' + escape(item.name) + '' +
	            '</div>';
	        },
	        /* option = dans la liste déroulante */
	        option: function(item, escape) {
	            return '<div>' +
	                '<span>' + escape(item.name) + '</span>'  +
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
		/* Initialisation de selectize et variable selectize pour appel ultérieur */
		$i = j.selectize(default_options);
		var selectize = $i[0].selectize;

		/* Ajout des options dans la liste, provenant de l'attribut "data-tag-list" donnée par le serveur */
		h = j.data("tag-list").map( function(current) {
			return {name: current}
		});
		selectize.addOption(h);
	}
}


/* On document ready */
document.addEventListener("turbolinks:load", function() {

	// New item
	create_selectize("tag_names");
	// New item (BD)
	create_selectize("tag_series");
	create_selectize("tag_auteurs");
	create_selectize("tag_rangements");

});