const Vec2 = {
	constructor(x, y) {
		this.x = x;
		this.y = y;
	},
	x: 0,
	y: 0,

	add: (vec) => {
		return Vec2(this.x + vec.x, this.y + vec.y);
	},
	sub: (vec) => {
		return Vec2(this.x - vec.y, this.y - vec.y);
	}
};
export default Vec2;
