// Objects are the base interactable entity in the game other than Tiles.
import { Entity } from "/melon.js";
import Vec2 from "./vec.mjs";
class Obj {
	constructor() {
		
	}
	entity = new Entity();
	pos = new Vec2(0, 0);
	sprite = null;

	set_sprite = (sprite) => {
		this.sprite = sprite;
	};
};
export default Obj;
