
var ProductList = React.createClass({
	render: function() {
		return (
			<table className="table table-striped">
			  <tr>
			    <th></th>
			    <th>Titre</th>
					<th>Auteurs</th>
					<th>Note</th>
					<th>Remarque</th>
			  </tr>
			  {this.props.items.map(function(item) {
			  	return <ProductListItem item={item} />
			  })}
			</table>
		);
	}

});