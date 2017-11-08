
/* Remplace dan le texte tous les URL par des liens <a> */
function replaceURL(text) {
    var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
	return text.replace(exp,"<a href='$1' target='_blank'>$1</a>"); 
}


/* On document ready */
document.addEventListener("turbolinks:load", function() {
	console.log("TurboLinks:load");
	
	var exp1 = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/gi;
	var timer;

	/* Pour chaque post, remplacer le contenu commencant par http par un lien vers ce site */
	$(".post-message").each(function() {
		var modifiedHtml = replaceURL($(this).html(), exp1);
  		$(this).html(modifiedHtml);
	});

	/* Pour chaque commentaire, remplacer le contenu commencant par http par un lien vers ce site */
	$(".comment-message").each(function() {
		var modifiedHtml = replaceURL($(this).html(), exp1);
  		$(this).html(modifiedHtml);
	});

	/* Lance la génération de vignette lorsque l'utilisateur tape dans le champ "Nouveau post" */
	$("#post_message").keyup(function() {
		clearTimeout(timer);

		/* On ajoute un timer pour ne lancer la recherche regexp avec 500ms de latence */
	    timer = setTimeout(function() {
	 
	      	var text = $("#post_message").val();
			var elements = text.match(exp1);
			/* On ne lance la requete Ajax vers le serveur QUE si un URL est trouvé */
			if (elements && (elements.length > 0) ) {
				var url = elements[0];
				console.log("Requete Ajax Preview. url="+url);

				/* On affiche le div qui contiendra le preview */ 
				$('#live-preview').show();
				$('#live-preview').html("<i class='fa fa-refresh fa-spin fa-2x fa-fw preview-spinner'></i>");

		      	$.ajax('/posts/preview', {
		        	type: 'POST',
		        	data: { url: url },
		        	success: function(data, textStatus, jqXHR) {
		          		$("#live-preview").html(data);
		          		/* On enlève l'URL du texte de l'utilisateur si le preview réussi uniquement */
						$("#post_message").val( $("#post_message").val().replace(url, "") );
		        	},
		        	error: function() { 
		        		console.log("Erreur requete Ajax URL Preview"); 
		        		$("#live-preview").html("Erreur preview");
		        	}
		      	}); 
	      	}
	     }, 1000);

	});

});
