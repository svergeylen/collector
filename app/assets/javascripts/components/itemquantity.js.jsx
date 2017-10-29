
var ItemQuantity = React.createClass({
	getInitialState: function() {
		return {
			item: this.props.item
		}
	},

	render: function() {
		var itemquantityClasses = classNames({
			"itemquantity-box": true
		});

		/* Quantité */
		if (this.state.item.quantity > 1) {
			html = <span className='green'>{this.state.item.quantity}</span>;
		}
		else {
			if (this.state.item.quantity == 0) {
				html = <span className='fa fa-ban grey'></span>;
			}
			else {
				html = <span className='fa fa-check green'></span>;
			}
		}

		return (
			<div className={itemquantityClasses} title='mon titre'>
				<div className='itemquantity-gen itemquantity-minus' title='Diminuer' onClick={this.handleMinus}>
					<span className='glyphicon glyphicon-minus'></span>
				</div>
	            <div className='itemquantity-gen itemquantity-count'>{html}</div>
	            <div className='itemquantity-gen itemquantity-plus' title='Augmenter' onClick={this.handlePlus}>
					<span className='glyphicon glyphicon-plus'></span>
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
