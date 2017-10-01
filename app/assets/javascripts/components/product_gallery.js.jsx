
var ProductGallery = React.createClass({
	render: function() {
		return (
			<div className="row text-center text-lg-left" id="product-gallery">
				{this.props.items.map(function(item) {
					return <ProductGalleryItem item={item} key={item.id.toString()} />
				})}
			</div>
		);
	}

});

