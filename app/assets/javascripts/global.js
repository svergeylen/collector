
document.addEventListener("turbolinks:load", function() {
	var offset = 200;
	var duration = 300;

	$(window).scroll(function() {
		/* Bouton Back to top */
		if ($(this).scrollTop() > offset) {
			$(".back-to-top").fadeIn(700);
		} 
		else {
			$(".back-to-top").fadeOut(700);
		}
	});

	$(".back-to-top").click(function(event) {
 		event.preventDefault();
		$("html, body").animate({scrollTop: 0}, duration);
		return false;
	});

});