
var UpVote = React.createClass({
	/* Conversion de l'element stocké en this.props vers this.states à l'initialiation pour pouvoir modifier les valeurs */
	getInitialState: function() {
		return {
			element: this.props.element
		}
	},

	render: function() {
		var btnClasses = classNames({
			"btn": true,
			"btn-default": true
		});
		var glyphClasses = classNames({
			"fa": true,
			"fa-thumbs-up": this.state.element.up_voted,
			"fa-thumbs-o-up" : !this.state.element.up_voted
		});

		/* Construction du titre pour contenir les noms des gens qui like l'élement et la date du like. */
		var title = this.state.element.title+ "\n";
		$.each(this.state.element.voters, function(i, el) { 
			title+= el.voter_name+" ("+ (el.updated_at) +")\n" 
		});

		return (
			<button name='button' type='button' className={btnClasses} onClick={this.handleClick} title={title} >
	            <span className='upvote-count'>{this.state.element.up_votes}</span>
	            <span className={glyphClasses}></span>
			</button>
		);
	},

	handleClick: function() {
		var that = this;
		$.ajax({
			type: 'POST',
			url: this.props.element.route,
			success: function(data) {
				console.log("Back from server : %O", data);
				that.setState({ element: data.element })
			}

		});

	}
});