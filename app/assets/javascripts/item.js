
/* Instantiation de selectize sur un champ <select> 
   et ajout des elements listés dans data-selected comme valeurs prédéfinies 
   Renvoie l'instance selectize crée */
function create_selectize(id) {

	var default_options = {
		delimiter: ',',
		persist: false,
		maxItems: 30,
		openOnFocus: false,
		createOnBlur: true,
		hideSelected: true,
		placeholder: "",
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

/* On document ready */
document.addEventListener("turbolinks:load", function() {

	// New,Edit item
	tag_names = create_selectize("tag_names");
	tag_series = create_selectize("tag_series");
	tag_auteurs = create_selectize("tag_auteurs");
	tag_rangements = create_selectize("tag_rangements");

	// New,Edit Tag
	parent_tag_names = create_selectize("parent_tag_names");

	// Show tag : actions en bas de page : modification du rangement de plusieurs items sélectionnés
	rangements = create_selectize("rangements");

	// Modification de l'item_type dans les formulaire edit/new item
	$("#item_type").change(function(e) {
		item_type = $(this).val();
		$(location).attr('href', location.pathname+"?item_type="+item_type);
	});

});