
var ProductGallery = React.createClass({
	render: function() {
		return (
			<div className="row text-center text-lg-left">
				{this.props.items.map(function(item) {
					return <ProductGalleryItem item={item} />
				})}
			</div>
		);
	}

});

