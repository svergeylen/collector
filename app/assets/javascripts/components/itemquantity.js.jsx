
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

		/* Construction du titre pour contenir les noms des gens qui possèdent cet item. */
		var title = "";
		if (this.state.item.owners.length > 0) {
			title = "Item en possession de :\n"
			$.each(this.state.item.owners, function(i, el) { 
				title+= "- "+ el.name+" ("+el.quantity+")\n" 
			});
		}
		else {
			title = "Personne d'autre ne possède cet item"
		}


		/* Quantité */
		switch(this.state.item.quantity) {
		    case 0: {
		    	if(this.state.item.owners.length > 0) {
		        	html = <span className='fa fa-user grey'></span>;
				}
				else {
					html = <span className='fa fa-ban grey'></span>;
				}
				break;
		    }
		    case 1: {
		        html = <span className='glyphicon glyphicon-ok green'></span>;
		        break;
		    }
		    default: {
		        html = <span className='green'>{this.state.item.quantity}</span>;
		    }
		} 

		return (
			<div className={itemquantityClasses} title={title}>
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
