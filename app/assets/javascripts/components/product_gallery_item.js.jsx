
var ProductGalleryItem = React.createClass ({
	render: function() {
		return (
			<div className="col-lg-3 col-md-4 col-xs-6">
				<a href={this.props.item.show_path} className="d-block mb-4 h-100" >
					<img className="img-fluid img-thumbnail" src="http://placehold.it/400x300" alt="" />
				</a>
				<div>
					{this.props.item.name}
				</div>

				<UpVote item={this.props.item} />
			</div>
		);
	}
});
