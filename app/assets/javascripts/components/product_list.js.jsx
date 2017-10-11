
var ProductList = React.createClass({
	render: function() {
		return (
			<table className="table table-striped" id="product-list">
			  <thead>
				  <tr>
				    <th></th>
				    <th>Titre</th>
					<th>Auteurs</th>
					<th>Like</th>
					<th></th>
				  </tr>
			  </thead>
			  <tbody>
				  {this.props.items.map(function(item) {
				  	return <ProductListItem item={item} key={item.id.toString()} />
				  })}
			  </tbody>
			</table>
		);
	}

});