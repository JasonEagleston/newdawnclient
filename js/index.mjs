function keyPress(action, keyCode, down) {
	console.log(action, keyCode, down);
}
let onload = (me) => {
	if (!me.video.init(1024, 768, {parent: "screen", scaleMethod: "flex-width", renderer: me.video.WEBGL, depthTest: "z-buffer", subPixel: false})) {
		return alert("Your browser does not support HTML5 canvases!");
	}
	me.event.on(me.event.KEYDOWN, (action, keyCode) => {
		keyPress(action, keyCode, true);
	});
	me.event.on(me.event.KEYUP, (action, keyCode) => {
		keyPress(action, keyCode, false);
	});
}

export default onload;
