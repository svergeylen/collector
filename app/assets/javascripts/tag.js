

document.addEventListener("turbolinks:load", function() {

	/* Lorsque le nom d'un tag est modifié, définir la lettre de classement (si elle est vide) */
	var tn = $("input#tag_name");
	tn.change(function() {
		if ( $("input#tag_letter").val() == "") {
			$("input#tag_letter").val(tn.val().substring(0,1).toUpperCase())
		}
	});

});
