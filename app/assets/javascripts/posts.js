
var timer;
var is_loading_posts = false;
var current_page = 1;

/* Remplace dan le texte tous les URL par des liens <a> */
/* Est également appelé par comments/create.js.erb */
function replaceURL(text) {
    var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
	return text.replace(exp," <a href='$1' target='_blank'>Lien</a> "); 
}

/* Charge les posts de la page suivante s'il n'y a pas de chargement déjà en cours (is_loading_posts) */
function load_next_posts() {
	if (!is_loading_posts) {
		current_page += 1;
		console.log("Chargement de la page suivante :"+current_page);
		is_loading_posts = true;
		$("#posts").append("<div class='load_next_posts_spinner'><i class='fa fa-refresh fa-spin fa-2x fa-fw preview-spinner'></i><div>");
		$.ajax({
			url: "posts.js",
			data: { page: current_page},
			dataType: "script" /* Ceci implique que le script de index.js.erb soit exécuté */
		});
	}
}

/* Surveillance du défilement de la page pour charger les posts suivants. Appelé dans la view "post" */
function monitor_page_scroll() {
	/* Chargement des posts suivants lorsqu'on scrolle jusqu'en bas de la page (tolérance de xxx pixels) */
	$(window).scroll(function() {
		if ($(window).scrollTop() + $(window).height() + 100 >= $(document).height()) {
            load_next_posts();
        }
	});
}

/* Popper.js pour afficher les applaudissements dans un popup hover */
function add_poppers() {
	$('[data-toggle="popover"]').popover({
	  trigger: 'hover', 
	  html: true
	});
}

/* On document ready */
document.addEventListener("turbolinks:load", function() {

	// Popup Applaudissements
	add_poppers();

	// On confirme qu'aucun poste n'est en cours de chargement quand on recharge la page (nécéssaire lorqu'on utilise la fonction "back")
	is_loading_posts = false;

	/* Truc pour décaler la page vers un post donné (posts#141) malgré la navbar fixed qui donne un offset négatif */
	var shiftWindow = function() { scrollBy(0, -60) };
	if (location.hash) shiftWindow();
	window.addEventListener("hashchange", shiftWindow);

	/* Pour chaque post, remplacer le contenu commencant par http par un lien vers ce site */
	$(".post-message").each(function() {
		var modifiedHtml = replaceURL($(this).html());
  		$(this).html(modifiedHtml);
	});

	/* Pour chaque commentaire, remplacer le contenu commencant par http par un lien vers ce site */
	$(".comment-message").each(function() {
		var modifiedHtml = replaceURL($(this).html());
  		$(this).html(modifiedHtml);
	});

	/* Lance la génération de vignette lorsque l'utilisateur tape dans le champ "Nouveau post" */
	$("#post_message").keyup(function() {
		clearTimeout(timer);

		/* On ajoute un timer pour ne lancer la recherche regexp avec 1 sec de latence */
	    timer = setTimeout(function() {
	 
	      	var text = $.trim($("#post_message").val());

	      	/* On recherche si le texte COMMENCE (^) par un URL -> Si oui, on lance la preview */
			var elements = text.match(/^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/gi);
			
			/* On ne lance la requete Ajax vers le serveur QUE si un URL est trouvé en début de message */
			if (elements && (elements.length > 0) ) {
				var url = elements[0];
				console.log("URL preview. url="+url);

				/* On cherche si c'est un lien Youtube et dans ce cas l'identifiant de la vidéo */
				var youtube_pattern = new RegExp(/https?:\/\/(www\.)?youtube.com/gi); // https://youtu.be/
				var is_youtube = youtube_pattern.test(url);
				var youtube_id = "";
				if (is_youtube) {
					var start = url.indexOf("v=");
					youtube_id = url.substr(start+2);
					var end = youtube_id.indexOf("&");
					if (end != -1) {
						youtube_id = youtube_id.substr(0, end);
					}
				}

				/* On affiche le div qui contiendra le preview */ 
				$('#live-preview').show();
				$('#live-preview').html("<i class='fa fa-refresh fa-spin fa-2x fa-fw preview-spinner'></i>");

				/* On lance la requete serveur pour rassembler les informations de la page */
		      	$.ajax('/posts/preview', {
		        	type: 'POST',
		        	data: { url: url,
		        			youtube_id: youtube_id
		        		  },
		        	success: function(data, textStatus, jqXHR) {
		          		$("#live-preview").html(data);
		          		/* On enlève l'URL du texte de l'utilisateur uniquement si le preview a réussi */
						$("#post_message").val( $("#post_message").val().replace(url, "") );
		        	},
		        	error: function() { 
		        		console.log("Erreur requete Ajax URL Preview"); 
		        		$("#live-preview").html("Pas de vignette");
		        	}
		      	}); 
	      	}
	     }, 1000);

	});

});
