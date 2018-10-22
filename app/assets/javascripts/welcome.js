
document.addEventListener("turbolinks:load", function() {

	/* On ne souhaite pas envoyer le champ de recherche au serveur... C'est autocomplete remplace document.href */
    $("#search_tags_form").submit(function(e){
        e.preventDefault();
    });

	/* Formulaire de recherche de search_tags_form (autocomplete)  */
	var tags = $("#collector-tag-search").data("options");
	/* Fonction pour normaliser les accents vers les lettres sans accents les plus proches */
	var accentMap = { "á": "a", "à": "a", "ä": "a", "â": "a", "é": "e", "è": "e", "ë": "e", "ê": "e", "ï": "i", "î": "i", "ö": "o", "ô": "o", "ù": "u", "û": "u", "ü": "u" };
  var normalize = function( term ) {
    var ret = "";
    for ( var i = 0; i < term.length; i++ ) {
      ret += accentMap[ term.charAt(i) ] || term.charAt(i);
    }
    return ret;
  };
 	/* JQUERY-UI  : AUTO COMPLETE */
  $( "#collector-tag-search" ).autocomplete({
    autoFocus: true,
    source: function( request, response ) {
    	/* Construction du regexp pour utilisation ultérieure. Insensitif à la casse */
      var matcher = new RegExp( $.ui.autocomplete.escapeRegex( request.term ), "i" );

      /* la réponse true/false est la résultat de la fonction grep (filtre) de la liste de tags */
      response( $.grep( tags, function( value ) {
      		/* la valeur à prendre dans la liste d'options */
        		value = value.label; // || value.value || value;
        		/* True si le texte entré correspond uen entrée de la liste ou a son équivalent normalisé */
        		return matcher.test( value )   || matcher.test( normalize( value )  ) ;
      	}) 
      );
    },
    select: function( event, ui ) { 
      /* console.log("Sélection : "+ ui.item.value+ " - "+ui.item.label+" - "+ui.item.id); */
      /* window.location.href = "/tags/"+ui.item.id; */
      $(location).attr("href", "/tags/"+ui.item.id+"?add=1");
    }
  });


});