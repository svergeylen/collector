
document.addEventListener("turbolinks:load", function() {

	/* Link disabled. Bootstrap fait juste du visuel mais ne bloque pas le clic sans ce code */
	$("li.disabled a").click(function() {
    	return false;
   	});
});
