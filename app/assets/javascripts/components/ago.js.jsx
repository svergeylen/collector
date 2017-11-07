
var Ago = React.createClass({
	getInitialState: function() {
		return {
			now: Math.round((new Date().getTime()/1000)),
			delta: NaN
		}
	},

	componentDidMount() {
		/* J'appelle tick uen première fois sinon les valeurs sont NaN... (pq ?) */
		this.tick();
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
		var ajd = new Date(this.props.since*1000);
		var day = (ajd.getDate()  < 10) ? "0"+ajd.getDate()    : ajd.getDate();
		var hour = ajd.getHours();
		var minutes = (ajd.getMinutes()  < 10) ? "0"+ajd.getMinutes() : ajd.getMinutes();
		var month = mois[ajd.getMonth()];
		var title = "Le "+day+" "+month+" "+ajd.getFullYear()+", à "+hour+"h"+minutes;
	
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
					/* Vérification si le timestamp est encore d'aujourd'hui ou plus ancien */
					
					var minuit = new Date();
					minuit.setHours(0,0,0,0);
					var hier_minuit = new Date();
					hier_minuit.setHours(0,0,0,0);
					hier_minuit.setDate(ajd.getDate() - 1);
					
					/* C'est encore aujourd'hui */
					if (ajd > minuit) {
						text = "Aujourd'hui, à "+hour+"h"+minutes;
					}
					/* C'était avant minuit et donc hier */
					else {
						if (ajd > hier_minuit) {
							text = "Hier, à "+hour+"h"+minutes;
						}
						/* C'était avant hier minuit. On peut arrondir au jour près */
						else {
							if (val < (7*24*3600)) {
								tmp = Math.round(val/(3600*24));
								text = "Il y a "+tmp+" jour";
								if (tmp > 1) {text+= "s"; }
							}
							else {
								text = title;
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