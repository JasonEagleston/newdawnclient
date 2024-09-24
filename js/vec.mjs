class Vec2 {
	constructor(x, y) {
		this.x = x;
		this.y = y;
	}
	x = 0;
	y = 0;

	add = (vec) => {
		return new Vec2(this.x + vec.x, this.y + vec.y);
	}
	sub = (vec) => {
		return new Vec2(this.x - vec.x, this.y - vec.y);
	}
};
export default Vec2;
