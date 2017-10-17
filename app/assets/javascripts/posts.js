
// http://stackoverflow.com/questions/37684/how-to-replace-plain-urls-with-links
function replaceURLWithHTMLLinks(text) {
    var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
    return text.replace(exp,"<a href='$1' target='_blank'>$1</a>"); 
}



// $( document ).ready(function() {   //// deprecated becaue of turbolinks 5
document.addEventListener("turbolinks:load", function() {

	/* Pour chaque post, remplacer le contenu commencant par http par un lien vers ce site */
	$(".post-message").each(function() {
		var modifiedHtml = replaceURLWithHTMLLinks($(this).html());
  		$(this).html(modifiedHtml);
	});

	/* Pour chaque commentaire, remplacer le contenu commencant par http par un lien vers ce site */
	$(".comment-message").each(function() {
		var modifiedHtml = replaceURLWithHTMLLinks($(this).html());
  		$(this).html(modifiedHtml);
	});
});
