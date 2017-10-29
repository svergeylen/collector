
var ItemQuantity = React.createClass({
	getInitialState: function() {
		return {
			item: this.props.item
		}
	},

	render: function() {
		var topClasses = classNames({
			"itemquantity-box": true
		});

		/* Quantité */
		if (this.state.item.quantity > 1) {
			html = this.state.item.quantity;
		}
		else {
			if (this.state.item.quantity == 0) {
				html = "0";
			}
			else {
				html = 'V'; /* <span className="fa fa-check"></span> */
			}
		}

		return (
			<div className={topClasses} title='mon titre'>
	            <div className='itemquantity-count'>{html}</div>
	            <div className='itemquantity-actions'>
	            	<div className='fa fa-caret-up ' title='Augmenter' onClick={this.handlePlus}></div>
	            	<div className='fa fa-caret-down' title='Diminuer' onClick={this.handleMinus}></div>
            	</div>
			</div>
		);
	},

	handleMinus: function() {
		this.send_ajax(-1);
	},

	handlePlus: function() {
		this.send_ajax(1);
	},

	send_ajax(delta) {
		var that = this;
		$.ajax({
			type: 'POST',
			url: this.props.item.route,
			data : { delta: delta},
			success: function(data) {
				console.log("send_ajax: Back from server : %O", data);
				that.setState({ item: data.item })
			}
		});
	}


});
