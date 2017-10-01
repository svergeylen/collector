
var ProductGalleryItem = React.createClass ({
	render: function() {
		return (
			<div className="col-lg-3 col-md-4 col-xs-6" >
				<div className="item-card">
					<a href={this.props.item.show_path} className="d-block mb-4 h-100" >
						<img className="img-fluid" src="http://placehold.it/400x300" alt="" />
					</a>

					<div className="item-caption">
						<UpVote item={this.props.item} />

						<div className="item-name">
							{this.props.item.name}
						</div>
					</div>
				</div>
			</div>
		);
	}
});
