
var SeriesList = React.createClass({
	getInitialState : function() {
		console.log("getInitialState");
	    return {
	      current_view : this.props.default_view
	    };
	},
	handleClick : function(desired_view) {
		console.log("Activate List : %O",desired_view);
		this.setState({
		  current_view : desired_view
		});
	},

	render: function() {

		let comp1 = null;
		if (this.state.current_view == "list") {
	      comp1 = <ProductList items={this.props.items} />;
	    } else {
	      comp1 = <ProductGallery items={this.props.items} />;
	    }


		return (

			<div className="series-show">
				<div className="btn-group">
					<button type="button" className="btn btn-default btn-sm" onClick={this.handleClick.bind(this, "list")}>
						<span className="glyphicon glyphicon-th-list"></span>
					</button>
					<button type="button" className="btn btn-default btn-sm" onClick={this.handleClick.bind(this, "gallery")}>
						<span className="glyphicon glyphicon-th"></span>
					</button>

					<button type="button" className="btn btn-default dropdown-toggle btn-sm" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						<span className="glyphicon glyphicon-cog" aria-hidden="true"></span>  <span className="caret"></span>
					</button>
					<ul className="dropdown-menu pull-right">
						<li>
							<a href={this.props.edit_path}>
								Modifier la série
							</a>
						</li>

						<li>
							<a data-confirm="Supprimer la série entière et tous les éléments qu'elle contient ?" rel="nofollow" data-method="delete" href={this.props.delete_path}>
								Supprimer la série
							</a>
						</li>
					</ul>
				</div>
			
				<h1>
					{this.props.name}
				</h1>
				
				{comp1}
				
			</div>
		);
	}

	
});

