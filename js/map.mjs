class Map {
	width = 0;
	height = 0;
	tiles = [];

	get_tile = (x, y) => {
		return (x >= this.height || y >= this.width) ? null : this.tiles[y * this.width + x];
	};
	set_tile = (x, y, tile) => {
		this.tiles[y * this.width + x] = tile;
	};
}
export default Map;
