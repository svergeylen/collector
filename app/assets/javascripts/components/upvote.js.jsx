
var UpVote = React.createClass({
	/* Conversion de l'item stocké en this.props vers this.states à l'initialiation pour pouvoir modifier les valeurs */
	getInitialState: function() {
		return {
			item: this.props.item
		}
	},

	render: function() {
		var divClasses = classNames({
			"item-upvote": true,
			"item-upvote-no": !this.state.item.up_voted,
			"item-upvote-yes": this.state.item.up_voted
		});

		return (
			<div className={divClasses} onClick={this.handleClick} >
				<div className="item-upvote-count">
					{this.state.item.up_votes}
				</div>
			</div>
		);
	},

	handleClick: function() {
		var that = this;
		$.ajax({
			type: 'POST',
			url: Routes.upvote_item_path(this.props.item.id, {format: 'json' }),
			success: function(data) {
				that.setState({ item: data})
			}

		});

	}
});