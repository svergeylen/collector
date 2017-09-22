$( document ).ready(function() {

	// Ouvre et initialise la fenetre modale pour mettre un avis sur un item
	$( ".with_modal_window" ).click(function(e) {
		e.preventDefault();
		$("#avis").modal();
		$("#avis #item-title").html( $(this).data("item-title"));
		$("#avis #item-id").val( $(this).data("item-id"));
		$("#avis #item-note").val( $(this).data("item-note"));
		$("#avis #item-remark").val( $(this).data("item-remark"));

		// Greffon star-rating

		$("#item-note").rating({
			size: "sm",   // xl, lg, md, sm, or xs
			min: 0,
			max: 5,
			step: 1,
			clearButtonTitle: "Pas de note",
			clearCaption: "Pas de note",
			showCaption: true,
			starCaptions:     {
        0.5: 'Moyen',
        1: 'Moyen',
        1.5: 'Bien',
        2: 'Bien',
        2.5: 'Très bien',
        3: 'Très bien',
        3.5: 'Recommandé',
        4: 'Recommandé',
        4.5: 'Excellent',
        5: 'Excellent'
    	}
		});
	});

});
