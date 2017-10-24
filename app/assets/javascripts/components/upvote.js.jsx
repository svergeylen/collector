
var UpVote = React.createClass({
	/* Conversion de l'element stocké en this.props vers this.states à l'initialiation pour pouvoir modifier les valeurs */
	getInitialState: function() {
		return {
			element: this.props.element
		}
	},

	render: function() {
		var divClasses = classNames({
			"upvote": true,
			"upvote-no": !this.state.element.up_voted,
			"upvote-yes": this.state.element.up_voted
		});

		return (
			<div className={divClasses} onClick={this.handleClick} >
				<div className="upvote-count">
					{this.state.element.up_votes}
				</div>
			</div>
		);
	},

	handleClick: function() {
		var that = this;
		$.ajax({
			type: 'POST',
			url: this.props.element.route,
			success: function(data) {
				console.log(data);
				that.setState({ element: data})
			}

		});

	}
});