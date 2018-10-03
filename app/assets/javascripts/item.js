
/* Instantiation de selectize sur un champ <select> 
   et ajout des elements listés dans data-selected comme valeurs prédéfinies 
   Renvoie l'instance selectize crée */
function create_selectize(id) {

	var default_options = {
		delimiter: ',',
		persist: false,
		maxItems: 30,
		createOnBlur: true,
		hideSelected: true,
		placeholder: "?",
		closeAfterSelect: true,
		valueField: 'name',
    	labelField: 'name',
    	searchField: ['name'],
    	render: {
    		/* item = dans le champ input text */
	        item: function(item, escape) {
	            return '<div class="collector-tag collector-tag-filter"> ' +
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
	
	var selectize;
	var j = $("#"+id);
	// console.log(j);
	if (j.length) {
		/* Initialisation de selectize et variable selectize pour appel ultérieur */
		$i = j.selectize(default_options);
		selectize = $i[0].selectize;

		/* Ajout des options dans la liste, provenant de l'attribut "data-tag-list" donnée par le serveur */
		h = j.data("tag-list").map( function(current) {
			return {name: current}
		});
		selectize.addOption(h);		
	}

	return selectize;
}

/* Mémorisation des instances selectize pour éviter d'en créer de nouvelles en cas de back/forward du navigateur */
// var tag_names;
// var tag_series;
// var tag_auteurs;
// var tag_rangements;
// var parent_tag_names;

/* On document ready */
document.addEventListener("turbolinks:load", function() {

	// New,Edit item
	// if (tag_names == undefined) {
		tag_names = create_selectize("tag_names");
	// }
	// // New,Edit item (BD)
	// if (tag_series == undefined) {
		tag_series = create_selectize("tag_series");
	// }
	// if (tag_auteurs == undefined) {
		tag_auteurs = create_selectize("tag_auteurs");
	// }
	// if (tag_rangements == undefined) {
		tag_rangements = create_selectize("tag_rangements");
	// }

	// // New,Edit Tag
	// if (parent_tag_names == undefined) {
		parent_tag_names = create_selectize("parent_tag_names");
	// }

});