
var SeriesList = React.createClass({
	render: function() {
		return (
			<div className="series-show">
						
				<div className="btn-group">
					<button type="button" className="btn btn-default dropdown-toggle btn-sm" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						<span className="glyphicon glyphicon-cog" aria-hidden="true"></span>  <span className="caret"></span>
					</button>
					<ul className="dropdown-menu pull-right">
						<li>
							<a href="#">
								<span className="glyphicon glyphicon-th-list"></span> Liste
							</a>
						</li>
						<li>
							<a href="#">
								<span className="glyphicon glyphicon-th"></span> Galerie
							</a>
						</li>
						<li className="divider"></li>
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
				
				
				<ProductList items={this.props.items} />
				
		  
			</div>
		);
	}

});

