import Obj from "./obj.mjs";

function keyPress(action, keyCode, down) {

}

class GameState {
	objs = [];
}

function CheckLogin() {
	document.getElementById("login").style.visiblity = "visible";
}



let onload = (me, socket) => {
	if (!me.video.init(1024, 768, {parent: "screen", renderer: me.video.WEBGL, depthTest: "z-buffer", subPixel: false})) {
		return alert("Your browser does not support HTML5 canvases!");
	}
	me.event.on(me.event.KEYDOWN, (action, keyCode) => {
		keyPress(action, keyCode, true);
	});
	me.event.on(me.event.KEYUP, (action, keyCode) => {
		keyPress(action, keyCode, false);
	});
	me.event.on(me.event.GAME_AFTER_UPDATE, (time) => {

	});

	return CheckLogin();
}
export default onload;
