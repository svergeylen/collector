
var Ago = React.createClass({
	getInitialState: function() {
		var now = Math.round((new Date().getTime()/1000));
		return {
			now: now,
			delta: (now - this.props.since)
		}
	},

	componentDidMount() {
	    this.timerID = setInterval(  () => this.tick(), 10000 );
	},

	componentWillUnmount() {
	    clearInterval(this.timerID);
	},

	tick() {
	    this.setState({
	    	now: Math.round((new Date().getTime()/1000))
	    });
	    this.setState({
	    	delta: this.state.now - this.props.since
	    });
	},

	render: function() {
		var text = "";
		var mois = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"];
		var val = this.state.delta;
		var since = new Date(this.props.since*1000);
		var day = (since.getDate()  < 10) ? "0"+since.getDate()    : since.getDate();
		var hour = since.getHours();
		var minutes = (since.getMinutes()  < 10) ? "0"+since.getMinutes() : since.getMinutes();
		var month = mois[since.getMonth()];
		var title = "Le "+day+" "+month+" "+since.getFullYear()+", à "+hour+"h"+minutes;

		/* Moins de une minute */
		if (val < 60) {
			text = "A l'instant !";
		}
		else {
			/* Moins de une heure */
			if (val < 3600) {
				tmp = Math.floor(val / 60);
				text = "Il y a "+tmp+ " minute";
				if (tmp > 1) { text += "s" }
			}
			else {
				/* Moins de 5 heures */
				if (val < (5*3600) ) {
					tmp = Math.floor(val / 3600);
					text = "Il y a "+tmp+" heure";
					if (tmp > 1) { text += "s" }
				}
				else {
					/* Création d'une variable fixe à minuit, pour voir si cela date d'aujourd'huir */
					var minuit = new Date();
					minuit.setHours(0,0,0,0);

					/* Création d'un variable fixe hier à minuit, pour voir si c'est d'hier */
					var hier_minuit = new Date();
					hier_minuit.setHours(0,0,0,0);
					hier_minuit.setDate(hier_minuit.getDate() - 1);
					
					/* C'est d'aujourd'hui */
					if (since > minuit) {
						text = "Aujourd'hui, à "+hour+"h"+minutes;
					}
					/* C'était avant minuit et donc hier */
					else {
						if (since > hier_minuit) {
							text = "Hier, à "+hour+"h"+minutes;
						}
						/* C'était avant hier minuit. On peut arrondir au jour près */
						else {
							/* Dans la semaine, on donne le nombre de jours depuis */
							if (val < (7*24*3600)) {
								tmp = Math.round(val/(3600*24));
								text = "Il y a "+tmp+" jour";
								if (tmp > 1) {text+= "s"; }
							}
							else {
								text = "Le "+day+" "+month+" "+since.getFullYear();
							}
						}
					}
				}
			}
		}

		return (
	      <span className="time" title={title} >{text}</span>
	    );
	}
});