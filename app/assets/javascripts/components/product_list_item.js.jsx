
var ProductListItem = React.createClass ({
	render: function() {
		return (
			<tr>
			  <td>{this.props.item.numero}</td>
				<td>{this.props.item.name}</td>
				<td>{this.props.item.authors}</td>
				<td>
					<UpVote item={this.props.item} />
				</td>
				<td></td>
			</tr>
		);
	}
});