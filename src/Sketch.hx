package;

import Sketch.Global.*;
import js.Browser.*;
import js.html.*;
import js.html.MouseEvent;
import js.html.CanvasElement;

/**
 * inspired by George Gally, which was inpired by Seb Lee
 * https://github.com/GeorgeGally/creative_coding/blob/master/js/canvas.js
 *
 * The name is again inspired by ...
 */
class Sketch {
	public var window = js.Browser.window;
	public var document = js.Browser.document;
	public var canvas:js.html.CanvasElement;
	public var ctx:CanvasRenderingContext2D;

	static public var option:SketchOption = new SketchOption();

	public function new() {}

	// https://github.com/soulwire/sketch.js/wiki/API#class-methods
	// ____________________________________ class-methods ____________________________________
	public static function create(name:String, ?opt:SketchOption):CanvasRenderingContext2D {
		// console.log(Sketch.option);
		// console.log(opt);

		if (opt != null) {
			Sketch.option = opt;
		}
		if (Sketch.option.type == SketchType.CANVAS) {
			return new Sketch().createCanvas(name);
		} else {
			return new Sketch().createGLCanvas(name);
		}
	}

	// this enables me to have many canvases all positioned on top of eachother at 100% width and height of page
	public function createCanvas(name:String):CanvasRenderingContext2D {
		var body = document.querySelector('body');

		var container = document.createDivElement();
		container.className = 'container';

		canvas = document.createCanvasElement();
		canvas.setAttribute("id", name);
		// canvas.style.position = "absolute";
		// canvas.style.left = "0px";
		// canvas.style.top = "0px";

		body.appendChild(container);
		container.appendChild(canvas);

		ctx = canvas.getContext('2d');
		new Sketch().init(ctx);
		onResizeHandler();
		window.addEventListener(RESIZE, onResizeHandler, false);
		return ctx;
	}

	public function createGLCanvas(name:String):CanvasRenderingContext2D {
		// canvas = document.createCanvasElement();
		// var body = document.querySelector('body');
		// canvas.setAttribute("id", name);
		// canvas.style.position = "absolute";
		// canvas.style.left = "0px";
		// canvas.style.top = "0px";
		// body.appendChild(canvas);
		// var gl:CanvasRenderingContext2D = canvas.getContext('webgl');
		// new Sketch().init();
		// if (gl == null)
		// 	var gl = canvas.getContext('experimental-webgl');
		// onResizeHandler();
		// window.addEventListener(RESIZE, resize, false);
		// return gl;
		return null;
	}

	function checkForId(id:String):Bool {
		return true;
	}

	function onResizeHandler() {
		var c:Array<CanvasElement> = cast document.getElementsByTagName('canvas');

		if (Sketch.option == null)
			return; // very weird that this happens, need to investigate

		if (Sketch.option.fullscreen) {
			w = window.innerWidth;
			h = window.innerHeight;
			Sketch.option.width = w;
			Sketch.option.height = h;
		} else {
			w = Sketch.option.width;
			h = Sketch.option.height;
		}
		for (i in 0...c.length) {
			var _c = c[i];
			if (Sketch.option.scale) {
				var padding = Sketch.option.padding;
				var scaleX = (window.innerWidth- (2 * padding)) / w;
				var scaleY = (window.innerHeight- (2 * padding)) / h;
				var scale = Math.min(scaleX, scaleY) ;
				_c.style.width = '${Sketch.option.width * scale}px';
				_c.style.height = '${Sketch.option.height * scale}px';
			}
			if (_c.id.indexOf('hiddencanvas-') != -1) {
				continue;
			}
			_c.width = w;
			_c.height = h;
		}
		console.log('RESIZE :: w=$w , h=$h');
	}

	/**
	 * so we need a canvas to sample from
	 * @param name
	 * @param option
	 */
	public static function createHiddenCanvas(name, ?option:SketchOption, ?isDebug:Bool = false):CanvasRenderingContext2D {
		if (option == null) {
			option = new SketchOption();
		}

		var body = document.querySelector('body');
		var canvas = document.createCanvasElement();
		body.appendChild(canvas);

		canvas.setAttribute("id", 'hiddencanvas-${name}');
		canvas.style.position = "absolute";
		canvas.style.left = "0px";
		canvas.style.top = "0px";
		canvas.style.border = "1px solid pink";
		canvas.style.width = "50%";
		canvas.width = option.width;
		canvas.height = option.height;
		if (!isDebug)
			canvas.style.left = -(option.width * 1.5) + "px";

		var ctx = canvas.getContext('2d');
		return ctx;
	}

	private function init(?ctx:CanvasRenderingContext2D) {
		// trace('init');

		window.addEventListener(MOUSE_MOVE, function(e:MouseEvent) {
			mouseX = e.clientX;
			mouseY = e.clientY;
			mouseMoved = true;
			// trace(mouseX, mouseY);
		});

		window.addEventListener(MOUSE_DOWN, function(e) {
			mouseDown = true;
			// trace('${mouseDown}');
			// if(typeof onMouseDown == 'function') onMouseDown();
		});

		window.addEventListener(MOUSE_UP, function(e) {
			mouseDown = false;
			// trace('${mouseDown}');
			// if(typeof onMouseUp == 'function') onMouseUp();
		});

		window.addEventListener(KEY_DOWN, function(e:js.html.KeyboardEvent) {
			// trace(e);
			if (e.metaKey == true && e.key == 'r') {
				trace('cmd + r');
				location.reload();
			}
			if (e.metaKey == true && e.key == 's' && e.shiftKey == false) {
				e.preventDefault();
				e.stopPropagation();
				trace('cmd + s');
				cc.util.ExportUtil.downloadImage(ctx, true);
			}
			if (e.metaKey == true && e.key == 's' && e.shiftKey == true) {
				e.preventDefault();
				e.stopPropagation();
				trace('cmd + shift + s');
				cc.util.ExportUtil.downloadImage(ctx, false);
			}
			if (e.metaKey == true && untyped e.code == 'KeyS' && e.altKey == true) {
				e.preventDefault();
				e.stopPropagation();
				trace('cmd + alt + s');
				cc.util.ExportUtil.onBase64Handler(ctx, true);
			}

			if (e.metaKey == true && e.key == 'f') {
				if (!isFullscreen) {
					openFullscreen();
					isFullscreen = true;
				} else {
					closeFullscreen();
					isFullscreen = false;
				}
			}
		}, false);

		// window.addEventListener(KEY_UP, function(e){
		// 	// if(typeof onKeyUp == 'function') onKeyUp(e);
		// });
	}

	/* View in fullscreen */
	function openFullscreen() {
		var elem = document.documentElement;
		if (elem.requestFullscreen != null) {
			elem.requestFullscreen();
		} else if (untyped elem.mozRequestFullScreen) { /* Firefox */
			untyped elem.mozRequestFullScreen();
		} else if (untyped elem.webkitRequestFullscreen) { /* Chrome, Safari and Opera */
			untyped elem.webkitRequestFullscreen();
		} else if (untyped elem.msRequestFullscreen) { /* IE/Edge */
			untyped elem.msRequestFullscreen();
		}
	}

	/* Close fullscreen */
	function closeFullscreen() {
		if (document.exitFullscreen != null) {
			document.exitFullscreen();
		} else if (untyped document.mozCancelFullScreen) { /* Firefox */
			untyped document.mozCancelFullScreen();
		} else if (untyped document.webkitExitFullscreen) { /* Chrome, Safari and Opera */
			untyped document.webkitExitFullscreen();
		} else if (untyped document.msExitFullscreen) { /* IE/Edge */
			untyped document.msExitFullscreen();
		}
	}
	// https://github.com/soulwire/sketch.js/wiki/API#instance-methods
	// ____________________________________ Instance Methods ____________________________________
	// start
	// stop
	// toggle
	// clear
	// destroy
	// https://github.com/soulwire/sketch.js/wiki/API#overridable-instance-methods
	// Overridable Instance Methods
	// Implement these methods on your sketch instance (or pass them to create inside the options hash).
	// setup
	// update
	// draw
	// touchstart
	// touchmove
	// touchend
	// mouseover
	// mousedown
	// mousemove
	// mouseout
	// mouseup
	// click
	// keydown
	// keyup
	// resize
}

// Constants
// CANVAS Enumeration for the Canvas type
// WEBGL Enumeration for the WebGL type
// DOM Enumeration for the DOM type
// instances A list of all current Sketch instances
@:enum abstract SketchType(String) {
	var CANVAS = 'canvas';
	var WEBGL = 'webgl';
	var DOM = 'dom';
}

@:enum abstract PaperSize(String) {
	var A6 = 'A6';
	var A5 = 'A5';
	var A4 = 'A4';
	var A3 = 'A3';
	var A2 = 'A2';
	var A1 = 'A1';
}

// https://github.com/soulwire/sketch.js/wiki/API#options
class SketchOption {
	public var width(get_width, set_width):Int;

	private var _width:Int;

	function get_width():Int {
		return _width;
	}

	function set_width(value:Int):Int {
		_fullscreen = false;
		if (_height == null)
			_height = value;
		return _width = value;
	}

	public var height(get_height, set_height):Int;

	private var _height:Int;

	function get_height():Int {
		return _height;
	}

	function set_height(value:Int):Int {
		_fullscreen = false;
		if (_width == null)
			_width = value;
		return _height = value;
	}

	// fullscreen Default: true; when false, you can pass width: 500, height: 500 to specify a size.
	public var fullscreen(get_fullscreen, set_fullscreen):Bool;

	private var _fullscreen:Bool = false;

	function get_fullscreen():Bool {
		return _fullscreen;
	}

	function set_fullscreen(value:Bool):Bool {
		return _fullscreen = value;
	}

	// autoclear Default: true Whether to clear the context before each call to draw. Otherwise call clear()
	public var autoclear(get_autoclear, set_autoclear):Bool;

	private var _autoclear:Bool = true;

	function get_autoclear():Bool {
		return _autoclear;
	}

	function set_autoclear(value:Bool):Bool {
		return _autostart = value;
	}

	// autostart Default: true Otherwise call start()
	public var autostart(get_autostart, set_autostart):Bool;

	private var _autostart:Bool = true;

	function get_autostart():Bool {
		return _autostart;
	}

	function set_autostart(value:Bool):Bool {
		return _autostart = value;
	}

	// ?????????????????
	// autopause Default: true Whether to pause the animation on window blur and resume on focus
	public var autopause(get_autopause, set_autopause):Bool;

	private var _autopause:Bool = true;

	function get_autopause():Bool {
		return _autopause;
	}

	function set_autopause(value:Bool):Bool {
		return _autopause = value;
	}

	// container Default: document.body Where to put the sketch context
	public var container(get_container, set_container):js.html.Element;

	private var _container:js.html.Element = document.body;

	function get_container():js.html.Element {
		return _container;
	}

	function set_container(value:js.html.Element):js.html.Element {
		return _container = value;
	}

	// type Default Sketch.CANVAS Possible values: Sketch.CANVAS, Sketch.WEB_GL and Sketch.DOM
	public var type(get_type, set_type):SketchType;

	private var _type:SketchType = SketchType.CANVAS;

	function get_type():SketchType {
		return _type;
	}

	function set_type(value:SketchType):SketchType {
		return _type = value;
	}

	// scale the canvas so you can see it without using the scrollbar
	public var scale(get_scale, set_scale):Bool;

	private var _scale:Bool = false;

	function get_scale():Bool {
		return _scale;
	}

	function set_scale(value:Bool):Bool {
		return _scale = value;
	}

	// scaling will use padding so you will see what you are doing
	public var padding(get_padding, set_padding):Int;

	private var _padding:Int = 20;

	function get_padding():Int {
		return _padding;
	}

	function set_padding(value:Int):Int {
		return _padding = value;
	}

	// interval Default: 1 The update / draw interval (2 will update every 2 frames, etc)
	// globals Default: true Add global properties and methods to the window
	// retina Default: false Resize for best appearance on retina displays. Can be slow due to so many pixels!
	// eventTarget If you want Sketch to bind mouse events to an element other than the Sketch canvas, you can specify that ele
	public function new() {}
}

class SketchBase {
	public var ctx:CanvasRenderingContext2D;
	public var isDrawActive:Bool = true;
	public var isDebug:Bool = false;

	/**
	 * constructor
	 * @param ctx
	 */
	public function new(ctx:CanvasRenderingContext2D) {
		trace('START :: ${toString()}');

		this.ctx = ctx;
		window.addEventListener(RESIZE, _reset, false);
		window.addEventListener(KEY_DOWN, _keyDown, false);
		window.addEventListener(KEY_UP, _keyUp, false);
		// window.addEventListener(KEY_DOWN, onKeyDown);
		setup();
		_draw(); // start draw loop
	}

	// ____________________________________ private ____________________________________
	// track key functions
	function _keyDown(e:js.html.KeyboardEvent) {
		switch (e.key) {
			case ' ':
				draw();
			default:
				// trace("case '" + e.key + "': trace ('" + e.key + "');");
		}
	}

	function _keyUp(e:js.html.KeyboardEvent) {}

	// trigger when window resize, draw function is still running, so clear canvas and restart with init
	function _reset() {
		ctx.clearRect(0, 0, w, h);
		_draw();
	}

	// wrapper around the real `draw` class
	function _draw(?timestamp:Float) {
		draw();
		if (isDrawActive)
			window.requestAnimationFrame(_draw);
	}

	// ____________________________________ public ____________________________________

	/**
	 * setup your art here, is also the best place to reset data
	 * when the browser resizes
	 */
	public function setup() {
		// trace('SETUP :: ${toString()} -> override public function draw()');
	}

	public function onKeyDown(e:js.html.KeyboardEvent) {
		// switch (e.key) {
		// 	case ' ':
		// 		drawShape();
		// 	default:
		// 		trace("case '" + e.key + "': trace ('" + e.key + "');");
		// }
	}

	// setup
	// update
	// draw
	// touchstart
	// touchmove
	// touchend
	// mouseover
	// mousedown
	// mousemove
	// mouseout
	// mouseup
	// click
	// keydown
	// keyup
	// resize

	/**
	 * the magic happens here, every class should have a `draw` function
	 */
	public function draw() {
		trace('DRAW :: ${toString()} -> override public function draw()');
	}

	/**
	 * pause the draw function (toggle function)
	 */
	public function pause() {
		isDrawActive = !isDrawActive;
	}

	/**
	 * stop draw function
	 */
	public function stop() {
		isDrawActive = false;
	}

	/**
	 * play draw function
	 */
	public function play() {
		isDrawActive = true;
	}

	/**
	 * Get className, with package
	 * @example:
	 * 		trace(toString()); // this file would be "art.CCBase"
	 */
	public function toString() {
		var className = Type.getClassName(Type.getClass(this));
		return className;
	}
}

/**
 * @source
 * 			https://groups.google.com/forum/#!topic/haxelang/CPbyE3WCvnc
 * 			https://gist.github.com/nadako/5913724
 */
class Global {
	public static var MOUSE_DOWN:String = 'mousedown';
	public static var MOUSE_UP:String = 'mouseup';
	public static var MOUSE_MOVE:String = 'mousemove';
	public static var KEY_DOWN:String = 'keydown';
	public static var KEY_UP:String = 'keyup';
	public static var RESIZE:String = 'resize';
	public static var mouseX:Int;
	public static var mouseY:Int;
	public static var mouseMoved:Bool;
	public static var mouseDown:Bool;
	public static var keyDown:Int;
	public static var keyUp:Int;
	public static var mousePressed:Int = 0;
	public static var mouseReleased:Int = 0;
	public static var isFullscreen:Bool = false;
	public static var TWO_PI:Float = Math.PI * 2;
	// allows me global access to canvas and it’s width and height properties
	public static var w:Int;
	public static var h:Int;
	// public static var width:Int;
	// public static var height:Int;
}