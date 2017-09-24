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
        0.5: 'Bien',
        1: 'Bien',
        1.5: 'Très bien',
        2: 'Très bien',
        2.5: 'Recommandé',
        3: 'Recommandé',
        3.5: 'Excellent',
        4: 'Excellent',
        4.5: 'Exceptionnel',
        5: 'Exceptionnel'
    	}
		});
	});

});
