
/* Vérifie si la valeur donnée existe déjà dans la liste des folder ou doit être créé coté serveur */
function updateForm(val) {
	if ($.inArray(val, j_folder_list) > -1) {
		console.log("Existant : " + val);
		$('#parent_name').prop('disabled', true);
	} else {
		console.log("NEW ! " + val);
		$('#parent_name').prop('disabled', false);
	}
}


document.addEventListener("turbolinks:load", function() {
	
	/* il faut que la liste des folder soit définie dans cette vue pour lancer le script autocompete */
	if (typeof j_folder_list !== 'undefined') {
	
		/* --- view ITEM _form : FOLDER NAME --- */
		/* Lorsque le nom d'un folder est modifié, définir la lettre de classement (si elle est vide) */
		var fn = $("input#folder_name");
		fn.change(function() {
			if ( $("#folder_letter").val() == "") {
				$("#folder_letter").val(fn.val().substring(0,1).toUpperCase())
			}
		});
		
		/* Suggestion pour le choix du dossier parmi les dossiers existants */
		fn.autocomplete({
			source: j_folder_list,
			autoFocus: true,
			classes: {
		  	"ui-autocomplete": "highlight"
			},
			delay: 0,
			change: function( event, ui ) {
				updateForm(this.value);
			},
			select: function( event, ui ) {
				updateForm(ui.item.value);
			}
		});
		
		/* --- view ITEM _form et FODLER _form : PARENT NAME  --- */
		/* This is for selection of PARENT, that shall exist in the list. --> Erase user input if not pick from the list */
		$("input#parent_name").autocomplete({
			source: j_folder_list,
			autoFocus: true,
			classes: {
		  	"ui-autocomplete": "highlight"
			},
			delay: 0,
			change: function( event, ui ) {
				console.log(ui);
				if ( !ui.item ) {
					console.log("effacement");
					$(this).val("");
				}
		  }
		});
	};
});
