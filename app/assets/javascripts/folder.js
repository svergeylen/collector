document.addEventListener("turbolinks:load", function() {

	/* Lorsque le nom d'un folder est modifié, définir la lettre de classement (si elle est vide) */
	var tn = $("input#folder_name");
	tn.change(function() {
		if ( $("#folder_letter").val() == "") {
			$("#folder_letter").val(tn.val().substring(0,1).toUpperCase())
		}
	});
	
});
