
document.addEventListener("turbolinks:load", function() {

	/* Sélection du premier élément de la liste des résultats de search gobal */
	$("div.search_results a:first").focus();


	/* Recherche de tags avec autocomplete : page d'accueil Collector */
	var tags = $("#collector-tag-search").data("options");
	var accentMap = { "á": "a", "à": "a", "ä": "a", "â": "a", "é": "e", "è": "e", "ë": "e", "ê": "e", "ï": "i", "î": "i", "ö": "o", "ô": "o", "ù": "u", "û": "u", "ü": "u" };

    var normalize = function( term ) {
      var ret = "";
      for ( var i = 0; i < term.length; i++ ) {
        ret += accentMap[ term.charAt(i) ] || term.charAt(i);
      }
      return ret;
    };
 
    $( "#collector-tag-search" ).autocomplete({
      source: function( request, response ) {
      	/* Construction du regexp pour utilisation ultérieure. Insensitif à la casse */
        var matcher = new RegExp( $.ui.autocomplete.escapeRegex( request.term ), "i" );

        /* la réponse true/false est la résultat de la fonction grep (filtre) de la liste de tags */
        response( $.grep( tags, function( value ) {
        		/* la valeur à prendre dans la liste d'options */
          		value = value.label; // || value.value || value;
          		/* True si le texte entré correspond uen entrée de la liste ou a son équivalent normalisé */
          		return matcher.test( value ) || matcher.test( normalize( value ) );
        	}) 
        );
      },
      select: function( event, ui ) { 
        console.log("Sélection : "+ ui.item.value+ " - "+ui.item.label+" - "+ui.item.id);
        window.location.href = "/tags/"+ui.item.id;
      }
    });


});
