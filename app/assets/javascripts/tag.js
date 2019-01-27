

document.addEventListener("turbolinks:load", function() {

	/* Lorsque le nom d'un tag est modifié, définir la lettre de classement (si elle est vide) */
	var tn = $("input#tag_name");
	tn.change(function() {
		if ( $("input#tag_letter").val() == "") {
			$("input#tag_letter").val(tn.val().substring(0,1).toUpperCase())
		}
	});

	/* Clic sur une card de la galerie ou d'une ligne dans la liste doit cocher le checkbox de l'item correspondant */
	$(".collector-item-li").click(function(e){
		toggle($(this));
	});

	/* Coche tous les items de la liste ou de la galerie */
	$("#check_all").click(function(e) {
		e.preventDefault();
		objects = $(".collector-item-li");
		$.each( objects, function( index, elem ) {
		  toggle(elem);
		});
	});

	/* Affiche ou cache les ancertes du tag (elders) */
	$("#elder_tags_button").click(function(e) {  
		$("#elder_tags").toggle("slide");    
	});

});

/* Coche le checkbox contenu dans la ligne de la liste ou dans la card de la gallerie */
function toggle(elem) {
	var item_id = $(elem).data("item-id");
	checkbox = $("#item_"+item_id);
	if (checkbox.prop("checked")) {
		checkbox.prop("checked", false);
		$(elem).removeClass("checked");
	}
	else {
		checkbox.prop("checked", true);
		$(elem).addClass("checked");
	}
}