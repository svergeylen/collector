
var ProductListItem = React.createClass ({
	render: function() {
		return (
			<tr>
			  <td>{this.props.item.numero}</td>
				<td>
					<a href={this.props.item.show_path} >{this.props.item.name}</a>
				</td>
				<td> 
					{this.props.item.authors.map (function(author, i) {
						return ( <a href={author.show_path} >{author.name}, </a> )
					}) }
				</td>
				<td>
					<UpVote item={this.props.item} />
				</td>
				<td></td>
			</tr>
		);
	}
});