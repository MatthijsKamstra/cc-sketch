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

/**
 * create a chaining rectangle, a test
 */
class Rectangle {
	// are always set
	private var _ctx:CanvasRenderingContext2D;

	// defaults
	@:isVar public var _x(get, set):Float = 100;
	@:isVar public var _y(get, set):Float = 100;
	@:isVar public var _radius(get, set):Float = 100;
	@:isVar public var _alpha(get, set):Float = 1; // 0 -> 1
	@:isVar public var _rotate(get, set):Int = 0; // weird for circles ???
	@:isVar public var _width(get, set):Float = 100;
	@:isVar public var _height(get, set):Float = 100;

	// Color
	private var _color:RGB = cc.util.ColorUtil.GRAY;
	private var _colorstoke:RGB = cc.util.ColorUtil.BLACK;
	// dashed line
	private var _line:Int;
	private var _gap:Int;
	private var _isDashed:Bool = false;

	@:isVar public var _gradient(get, set):js.html.CanvasGradient;

	// ____________________________________ constructor ____________________________________
	public function new(ctx:CanvasRenderingContext2D) {
		this._ctx = ctx;
	}

	/**
	 * var text = Rectangle.create (ctx).draw();
	 *
	 * @param ctx
	 * @return Rectangle
	 */
	static inline public function create(ctx:CanvasRenderingContext2D):Rectangle {
		var rectangle = new Rectangle(ctx);
		return rectangle;
	}

	// ____________________________________ properties ____________________________________

	inline public function x(x:Float):Rectangle {
		this._x = x;
		return this;
	}

	inline public function y(y:Float):Rectangle {
		this._y = y;
		return this;
	}

	inline public function width(w:Float):Rectangle {
		this._width = w;
		return this;
	}

	inline public function height(h:Float):Rectangle {
		this._height = h;
		return this;
	}

	inline public function pos(x:Float, y:Float):Rectangle {
		this._x = x;
		this._y = y;
		return this;
	}

	inline public function leftAlign():Rectangle {
		// this._textAlign = 'left'; // left/right/center
		return this;
	}

	inline public function rightAlign():Rectangle {
		// this._textAlign = 'right'; // left/right/center
		return this;
	}

	inline public function centerAlign():Rectangle {
		// this._textAlign = 'center'; // left/right/center
		return this;
	}

	inline public function rotate(degree:Int):Rectangle {
		this._rotate = degree;
		return this;
	}

	inline public function rotateLeft():Rectangle {
		this._rotate = -90;
		return this;
	}

	inline public function rotateRight():Rectangle {
		this._rotate = 90;
		return this;
	}

	inline public function rotateDown():Rectangle {
		this._rotate = 180;
		return this;
	}

	inline public function color(value:RGB):Rectangle {
		this._color = value;
		return this;
	}

	inline public function stroke(value:RGB):Rectangle {
		this._colorstoke = value;
		return this;
	}

	inline public function dotted(line:Int, ?gap:Int):Rectangle {
		this._line = line;
		if (gap == null)
			gap = line;
		this._gap = gap;
		this._isDashed = true;
		return this;
	}

	inline public function draw():Rectangle {
		// // draw to convast
		// _ctx.save(); // save current state

		// var previousColor = _ctx.fillStyle;
		// // check if color is set
		// if(_color != null){
		// 	_ctx.fillColourRGB(_color);
		// }

		// // restore canvas to previous position
		// _ctx.restore();

		// // restore previous color?
		// _ctx.fillStyle = previousColor;
		if (_isDashed) {
			_ctx.setLineDash([_line, _gap]);
		}
		_ctx.fillColourRGB(_color);
		_ctx.strokeColourRGB(_colorstoke);
		_ctx.rectangleFillStroke(_x, _y, _width, _height);

		// reset values
		if (_isDashed) {
			_ctx.setLineDash([]);
		}

		return this;
	}

	// ____________________________________ getter/setter ____________________________________

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

	function get__width():Float {
		return _width;
	}

	function set__width(value:Float):Float {
		return _width = value;
	}

	function get__height():Float {
		return _height;
	}

	function set__height(value:Float):Float {
		return _height = value;
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

	function get__gradient():js.html.CanvasGradient {
		return _gradient;
	}

	function set__gradient(value:js.html.CanvasGradient):js.html.CanvasGradient {
		return _gradient = value;
	}

	// ____________________________________ tostring ____________________________________
	public function toString() {
		// return haxe.Json.stringify(this);

		return ('Rectangl	// defaults
	@:isVar public var _x(get, set):Float = 100;
	@:isVar public var _y(get, set):Float = 100;
	@:isVar public var _radius(get, set):Float = 100;
	@:isVar public var _alpha(get, set):Float = 1; // 0 -> 1

		// may be wrong@:is
	Var public var _rotate(get, set):Int = 0; // weird for circles ???e: '

			+ haxe.Json.parse(haxe.Json.stringify(this)));
	}
}
