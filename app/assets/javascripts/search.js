
document.addEventListener("turbolinks:load", function() {

	/* Sélection du premier élément de la liste des résultats de search */
	$("a.results:first").focus();
	
	/* Envoie une requete ajax lorsqu'on tape dan le champ recherche (dans la page category#show) */
	/*$("#series_keyword").keyup(function() {
		var thekeyword = $('#series_keyword').val();
		var thecategory_id = $('#category_id').val();
		if (thekeyword.length >= 2) {
			$.ajax({
			    type: "GET",
			    url: "/search/keyword",
			    data: { series_keyword: thekeyword, category_id: thecategory_id },
			    dataType: "json",
			    success: function(data) {
			    	var ret = "";

			    	/* Si il y a des résultats de recharce, les trier et les lister */
					/* if (data.series.length > 0) {
				    	data.series.sort(function(a,b){
						   return (a.name==b.name) ? 0 : (a.name > b.name) ? 1 : -1;
						});

				    	ret += "<ul>";
				        $.each(data.series, function(index, obj){
				        	ret += "<li><a href='/series/"+obj.id+"' >"+obj.name+"</a></li>";
				        });
				        ret+= "</ul>";
				    }
				    /* Sinon, proposer un lien pour créer la série */
				    /* else {
				    	ret = "<p>Aucun résultat. <a href='/series/new?name="+data.keyword+"&category_id="+data.category_id+"'>Créer la série \""+data.keyword+"\"</a></p>"
				    }

				    $('#search_results').html(ret);
			    }
			});
		}
		else {
			$('#search_results').html("");
		}
	}); */

});
