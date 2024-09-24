const getRandNum = (min, max) => {
	return Math.random() * (max - min) + min;
}
// Vec2 test.

import Vec2 from "./vec.mjs";
let nums = [];
for (let i = 0; i < 4; i++) {
	nums[i] = getRandNum(1, 64000);
}
let vec_a = new Vec2(nums[0], nums[1]);
let vec_b = new Vec2(nums[2], nums[3]);
let vec_c = vec_a.add(vec_b);
if (console.assert(vec_c.x == nums[0] + nums[2] && vec_c.y == nums[1] + nums[3])) {
	console.log(vec_c, nums);
	console.log("Addition assertion failed.");
}
vec_c = vec_b.sub(vec_a);
if (console.assert(vec_c.x == nums[2] - nums[0] && vec_c.y == nums[3] - nums[1])) {
	console.log(vec_c, nums);
	console.log("Subtraction assertion failed.");
}
