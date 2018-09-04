

/* On document ready */
document.addEventListener("turbolinks:load", function() {

	/* Application de la librairie Javascript Chosen sur tous les champs de class=chosen-selec
	   Cette librairie permet une sélection multiple de tags en remplacement du dropdown classique
	*/
	$('.chosen-select').chosen({
	    placeholder_text_multiple: "Tapez les premières lettres...",
	    placeholder_text_single: "Tapez les premières lettres...",
	    no_results_text: "Pas de résultat",
	    search_contains: true,
	    disable_search: false,
	    width: "100%"
	});

	/* Filtrage des tags enfants lorsqu'on tape dans le champ input "filter" */
	$('input#tag_filter').keyup(function(){
		var searchText = $(this).val().toLowerCase();

        $('ul.children_tags > li').each(function(){
            currentLiText = $(this).text().toLowerCase();
            showCurrentLi = currentLiText.indexOf(searchText) !== -1;
            $(this).toggle(showCurrentLi, "slow");
        });     
    });

});
