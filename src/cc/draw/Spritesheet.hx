package cc.draw;

import js.html.CanvasRenderingContext2D;
import js.html.*;
import js.Browser.document;
import js.Browser.window;
// import cc.Global.*;
import cc.util.ColorUtil.RGB;
import cc.util.MathUtil.*;

using cc.CanvasTools;
using StringTools;

class Spritesheet {
	// are always set
	private var _ctx:CanvasRenderingContext2D;

	// defaults
	@:isVar public var _x(get, set):Float = 100;
	@:isVar public var _y(get, set):Float = 100;
	@:isVar public var _radius(get, set):Float = 100; // ????
	@:isVar public var _alpha(get, set):Float = 1; // 0 -> 1
	@:isVar public var _rotate(get, set):Int = 0;
	@:isVar public var _width(get, set):Int;
	@:isVar public var _height(get, set):Int;
	@:isVar public var _cellWidth(get, set):Int;
	@:isVar public var _cellHeight(get, set):Int;
	@:isVar public var _index(get, set):Int = 0;
	@:isVar public var _isDebug(get, set):Bool = false;
	@:isVar public var _isCentered(get, set):Bool = false;
	@:isVar public var _img(get, set):Image;
	@:isVar public var _fps(get, set):Int = 60; // default 60 fps
	@:isVar public var _scale(get, set):Float = 1;

	// image related stuff
	// loading
	// var _src:String;
	// var isLoaded:Bool = false;
	// var isDrawPreviouslyCalled:Bool = false;
	// animation
	private var _isAnimation:Bool = false;
	private var _isLoop:Bool = false;
	private var _loopRepeat:Int;
	private var _currentSprite:Int = 0;
	private var _fpsCounter:Int = 0;
	var _delayCounter:Int = 0;

	public var _totalFrame:Int;

	// ____________________________________ constructor ____________________________________
	public function new(ctx:CanvasRenderingContext2D, img:Image) {
		this._ctx = ctx;
		this._img = img;

		this._width = _img.width;
		this._height = _img.height;
		this._totalFrame = Math.round(this._width / this._cellWidth); // TODO fix this for horzontal and vertical total
		if (this._index > this._totalFrame)
			this._index = this._totalFrame;
	}

	/**
	 * Load a spritesheet via this class
	 *
	 * @example
	 *		Spritesheet.load(src, onLoadedComplete);
	 * 		function onLoadedComplete(img:Image) {
	 *			this._img = img;
	 *			isImageLoaded = true;
	 *		}
	 *
	 * @param src 					path to file
	 * @param onLoadComplete		complete handler to catch the image
	 */
	public static function load(src:String, onLoadComplete:Image->Void) {
		// create the image used
		var _img = new Image();
		_img.crossOrigin = "Anonymous";
		_img.src = src;
		_img.onload = function() {
			// trace('w: ' + _img.width);
			// trace('h: ' + _img.height);
			if (Reflect.isFunction(onLoadComplete))
				Reflect.callMethod(onLoadComplete, onLoadComplete, [_img]);
		}
	}

	/**
	 * var text = Text.create (ctx, 'Matthijs Kamstra aka [mck]').draw();
	 *
	 * @param ctx
	 * @param text
	 * @return Text
	 */
	static inline public function create(ctx:CanvasRenderingContext2D, img:Image):Spritesheet {
		var spritesheet = new Spritesheet(ctx, img);
		return spritesheet;
	}

	// ____________________________________ properties ____________________________________

	inline public function x(x:Float):Spritesheet {
		this._x = x;
		return this;
	}

	inline public function y(y:Float):Spritesheet {
		this._y = y;
		return this;
	}

	inline public function pos(x:Float, y:Float):Spritesheet {
		this._x = x;
		this._y = y;
		return this;
	}

	inline public function cell(width:Int, height:Int):Spritesheet {
		this._cellWidth = width;
		this._cellHeight = height;

		// doesn't work, because of delay of loading
		this._totalFrame = Math.round(this._width / this._cellWidth); // TODO fix this for horzontal and vertical total
		return this;
	}

	/**
	 * show image number (zero based)
	 * @param index 	zero based,
	 * @return Spritesheet
	 */
	inline public function show(index:Int = 0):Spritesheet {
		this._index = index;
		return this;
	}

	/**
	 * show image number (zero based)
	 * @param index 	zero based,
	 * @return Spritesheet
	 */
	inline public function index(index:Int = 0):Spritesheet {
		this._index = index;
		return this;
	}

	inline public function animate():Spritesheet {
		this._isAnimation = true;
		return this;
	}

	inline public function center():Spritesheet {
		this._isCentered = true;
		return this;
	}

	inline public function img(img:Image):Spritesheet {
		this._img = img;
		return this;
	}

	inline public function scale(scale:Float):Spritesheet {
		this._scale = scale;
		return this;
	}

	inline public function debug(value:Bool):Spritesheet {
		this._isDebug = value;
		return this;
	}

	inline public function fps(value:Int):Spritesheet {
		this._fps = value;
		return this;
	}

	function pulseFun() {
		trace('pulse: ' + Date.now().getTime());
	}

	inline public function pulse(func:Void->Void):Spritesheet {
		Reflect.callMethod(pulseFun, func, []);
		return this;
	}

	inline public function loop(?nr:Int = -1):Spritesheet {
		this._isLoop = true;
		this._loopRepeat = nr;
		return this;
	}

	inline public function rotate(degree:Int):Spritesheet {
		this._rotate = degree;
		return this;
	}

	inline public function rotateLeft():Spritesheet {
		this._rotate = -90;
		return this;
	}

	inline public function rotateRight():Spritesheet {
		this._rotate = 90;
		return this;
	}

	inline public function rotateDown():Spritesheet {
		this._rotate = 180;
		return this;
	}

	inline public function alpha(alpha:Float):Spritesheet {
		this._alpha = clamp(alpha, 0, 1); // a value r should be between 0 and 1
		// this._alpha = alpha; // a value r should be between 0 and 1
		return this;
	}

	inline public function draw():Spritesheet {
		var xpos = 0;
		var ypos = 0;
		if (this._isCentered) {
			xpos = -Math.round((this._cellWidth) / 2);
			ypos = -Math.round((this._cellHeight) / 2);
		}

		// draw to convast
		_ctx.save(); // save current state

		// move canvas and rotate
		_ctx.translate(_x, _y);
		_ctx.rotate(radians(_rotate));
		// print sprite
		_ctx.clearRect(xpos, ypos, this._cellWidth * _scale, this._cellHeight * _scale);
		// draw each frame + place them in the middle
		var shiftX = this._currentSprite * this._cellWidth;
		var shiftY = 0; // FIX this later: this._index * this._cellHeight;

		// trace('shiftX: $shiftX , _currentSprite: $_currentSprite, _index: $_index');
		_ctx.scale(_scale, _scale);
		_ctx.drawImage(_img, shiftX, shiftY, this._cellWidth, this._cellHeight, xpos, ypos, this._cellWidth, this._cellHeight);

		// restore canvas to previous position
		_ctx.restore();

		/*
			Start at the beginning once you've reached the
			end of your sprite!
		 */
		this._fpsCounter++;
		this._currentSprite++;
		if (this._currentSprite > this._totalFrame) {
			if (this._isLoop) {
				this._currentSprite = this._index;
			} else {
				this._isAnimation = false;
				this._currentSprite = this._totalFrame - 1;
				draw();
			}
		}

		// loop counter?

		// trace('_fpsCounter: $_fpsCounter, _fps: $_fps - ${(60 / _fps)}');
		// trace(_fpsCounter % (60 / _fps) == 0);
		// trace(_fpsCounter % (60 / _fps) == 1);
		// trace(_fpsCounter % (60 / _fps) == 2);
		// trace(_fpsCounter % (60 / _fps) == 3);
		// trace(_fpsCounter % (60 / _fps) == 4);

		if (this._isAnimation) {
			trace('_fpsCounter: $_fpsCounter % 60 / $_fps -> ' + (_fpsCounter % (60 / _fps)));
			if (_fpsCounter % 60 / _fps == 0) {
				window.requestAnimationFrame(redraw);
			}
		}

		return this;
	}

	function redraw(?nr:Float) {
		draw();
	}

	// ____________________________________ getter setters ____________________________________

	function get__x():Float {
		return _x;
	}

	function set__x(value:Float):Float {
		return _x = value;
	}

	function get__y():Float {
		return _y;
	}

	function set__y(value:Float):Float {
		return _y = value;
	}

	function get__radius():Float {
		return _radius;
	}

	function set__radius(value:Float):Float {
		return _radius = value;
	}

	function get__alpha():Float {
		return _alpha;
	}

	function set__alpha(value:Float):Float {
		return _alpha = value;
	}

	function get__rotate():Int {
		return _rotate;
	}

	function set__rotate(value:Int):Int {
		return _rotate = value;
	}

	function get__cellHeight():Int {
		return _cellHeight;
	}

	function set__cellHeight(value:Int):Int {
		return _cellHeight = value;
	}

	function get__cellWidth():Int {
		return _cellWidth;
	}

	function set__cellWidth(value:Int):Int {
		return _cellWidth = value;
	}

	function get__height():Int {
		return _height;
	}

	function set__height(value:Int):Int {
		return _height = value;
	}

	function get__width():Int {
		return _width;
	}

	function set__width(value:Int):Int {
		return _width = value;
	}

	function get__index():Int {
		return _index;
	}

	function set__index(value:Int):Int {
		_currentSprite = value;
		return _index = value;
	}

	function get__isDebug():Bool {
		return _isDebug;
	}

	function set__isDebug(value:Bool):Bool {
		return _isDebug = value;
	}

	function get__img():Image {
		return _img;
	}

	function set__img(value:Image):Image {
		return _img = value;
	}

	function get__isCentered():Bool {
		return _isCentered;
	}

	function set__isCentered(value:Bool):Bool {
		return _isCentered = value;
	}

	function get__fps():Int {
		return _fps;
	}

	function set__fps(value:Int):Int {
		return _fps = value;
	}

	function get__scale():Float {
		return _scale;
	}

	function set__scale(value:Float):Float {
		return _scale = value;
	}

	// ____________________________________ tostring ____________________________________
	public function toString() {
		// return haxe.Json.stringify(this);
		return ('Spritesheet: ' + haxe.Json.parse(haxe.Json.stringify(this)));
	};
}
