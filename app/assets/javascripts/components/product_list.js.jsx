
var ProductList = React.createClass({
	render: function() {
		return (
			<table className="table table-striped">
			  <thead>
				  <tr>
				    <th></th>
				    <th>Titre</th>
					<th>Auteurs</th>
					<th>Like</th>
					<th>Remarque</th>
				  </tr>
			  </thead>
			  <tbody>
				  {this.props.items.map(function(item) {
				  	return <ProductListItem item={item} />
				  })}
			  </tbody>
			</table>
		);
	}

});