
var Ago = React.createClass({
	getInitialState: function() {
		return {
			now: Math.round((new Date().getTime()/1000)),
			delta: NaN
		}
	},

	componentDidMount() {
	    this.timerID = setInterval(  () => this.tick(), 60000 );
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
		var val = this.state.delta;
		var ajd = new Date(this.props.since*1000);
		var title = "Le "+ajd.getDate()+"/"+ajd.getMonth()+"/"+ajd.getFullYear()+", à "+ajd.getHours()+"h"+ajd.getMinutes();

		/* Moins de une minute */
		if (val < 60) {
			text = "A l'instant !";
		}
		else {
			/* Moins de une heure */
			if (val < 3600) {
				tmp = Math.floor(val / 60);
				text = "Il y a "+tmp+ " minute";
				if (tmp >= 2) { text += "s" }
			}
			else {
				/* Moins de 5 heures */
				if (val < (5*3600) ) {
					tmp = Math.floor(val / 3600);
					text = "Il y a "+tmp+" heure";
					if (tmp >= 2) { text += "s" }
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
						tmp = new Date(val * 1000);
						text = "Aujourd'hui, à "+ajd.getHours()+"h"+ajd.getMinutes();
					}
					/* C'était avant minuit et donc hier */
					else {
						if (ajd > hier_minuit) {
							text = "Hier, à "+ajd.getHours()+"h"+ajd.getMinutes();
						}
						/* C'était avant hier. On arrondit au jour près */
						else {
							if (val < (15*24*3600)) {
								tmp = Math.round(val/(3600*24));
								text = "Il y a "+tmp+" jour";
								if (tmp > 0) {text+= "s"; }
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
	      <div>{text}</div>
	    );
	}
});