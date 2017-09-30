
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
		return (

			<div className="series-show">
				

				<div>
			      Current_view = {this.state.current_view}
			    </div>

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
								<span className="glyphicon glyphicon-edit"></span> Modifier la série
							</a>
						</li>

						<li>
							<a data-confirm="Supprimer la série entière et tous les éléments qu'elle contient ?" rel="nofollow" data-method="delete" href={this.props.delete_path}>
								<span className="glyphicon glyphicon-trash"></span> Supprimer la série
							</a>
						</li>
					</ul>
				</div>
			
				<h1>
					{this.props.name}
				</h1>
				
				/// https://reactjs.org/docs/conditional-rendering.html
				<ProductGallery items={this.props.items} />
				
		  
			</div>
		);
	}

	
});

