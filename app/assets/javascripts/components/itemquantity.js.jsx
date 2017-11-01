
var ItemQuantity = React.createClass({
	getInitialState: function() {
		return {
			item: this.props.item
		}
	},

	render: function() {
		user_id = this.props.user_id;
		var that = this;

		/* Construction des utilisateurs qui possèdent l'article */
		/* Je recherche l'utiliateur courant pour l'afficher en premier dans la liste*/
		var result = $.grep(this.state.item.owners, function(el){ return el.user_id == user_id; });
		console.log(result);
		if (result.length > 0) {
			var me = that.picture(result[0]) ;
		}
		/* Autres posesseurs de l'article */
		var owners = this.state.item.owners.map(function(el, i) { 
			 if (el.user_id != user_id) {
				return that.picture(el);
			 }
		});

		/* Quantité */
		if (this.state.item.quantity == 0) {
			var quantity = <span className="glyphicon glyphicon-ban"></span>;
		}
		else {
			if (this.state.item.quantity == 1) {
				var quantity = <i className="fa fa-check"></i>;
			} else {
				var quantity = this.state.item.quantity;
			}
		}
		
		return (
			<div className='itemquantity-box'>
				<div className='itemquantity-actions'>
					<div className='glyphicon glyphicon-plus' title='Augmenter' onClick={this.handlePlus}></div>
					<div className='glyphicon glyphicon-minus' title='Diminuer' onClick={this.handleMinus}></div>
				</div>
	            <div className='itemquantity-count'>{quantity}</div>
	            <div className='itemquantity-owners'>{me} {owners}</div>
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
				that.setState({ item: data.item })
			}
		});
	},

	picture(el) {
		return <img src={el.avatar} className="profile-picture" title={el.name+" ("+el.quantity+"x)"} />
	}

});
