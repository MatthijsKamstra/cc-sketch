package cc.draw;

import js.html.CanvasRenderingContext2D;
import js.html.*;
import js.Browser.document;
import js.Browser.window;
// import cc.Global.*;
import cc.util.ColorUtil.RGB;
import cc.util.MathUtil.*;
import Sketch;
import Sketch.Global.*;

using cc.CanvasTools;
using StringTools;

class Mask {
	// are always set
	private var _ctx:CanvasRenderingContext2D;

	@:isVar public var _x(get, set):Float = 0;
	@:isVar public var _y(get, set):Float = 0;
	@:isVar public var _outerWidth(get, set):Float;
	@:isVar public var _outerHeight(get, set):Float;
	@:isVar public var _innerWidth(get, set):Float;
	@:isVar public var _innerHeight(get, set):Float;
	@:isVar public var _alpha(get, set):Float = 1; // 0 -> 1
	@:isVar public var _centered(get, set):Bool = true;

	//	// Color
	private var _color:RGB;
	private var _colorstoke:RGB;

	public function new(ctx:CanvasRenderingContext2D) {
		this._ctx = ctx;
	}

	/**
	 * var Mask = Mask.create (ctx).draw();
	 *
	 * @param ctx
	 *
	 * @return Mask
	 */
	static inline public function create(ctx:CanvasRenderingContext2D):Mask {
		var mask = new Mask(ctx);
		return mask;
	}

	// ____________________________________ properties ____________________________________

	inline public function x(x:Float):Mask {
		this._x = x;
		return this;
	}

	inline public function y(y:Float):Mask {
		this._y = y;
		return this;
	}

	inline public function pos(x:Float, y:Float):Mask {
		this._x = x;
		this._y = y;
		return this;
	}

	inline public function outerSquare(width:Float, height:Float):Mask {
		this._outerWidth = width;
		this._outerHeight = height;
		return this;
	}

	inline public function innerSquare(width:Float, height:Float):Mask {
		this._innerWidth = width;
		this._innerHeight = height;
		return this;
	}

	inline public function centered(isCentered:Bool = true):Mask {
		this._centered = isCentered;
		return this;
	}

	inline public function color(value:RGB):Mask {
		this._color = value;
		return this;
	}

	inline public function fill(value:RGB):Mask {
		this._color = value;
		return this;
	}

	inline public function stroke(value:RGB):Mask {
		this._colorstoke = value;
		return this;
	}

	inline public function alpha(value:Float):Mask {
		this._alpha = value;
		return this;
	}

	/**
	 * TODO: currenly only works with squares
	 * @return Mask
	 */
	inline public function draw():Mask {
		_ctx.beginPath();

		var _centerx = _outerWidth / 2;
		var _centery = _outerHeight / 2;

		var _outerW2 = _outerWidth / 2;
		var _outerH2 = _outerHeight / 2;
		var _innerW2 = _innerWidth / 2;
		var _innerH2 = _innerHeight / 2;

		// polygon1--- usually the outside polygon, must be clockwise
		_ctx.moveTo(_x, _y);
		_ctx.lineTo(_x + _outerWidth, _y);
		_ctx.lineTo(_x + _outerWidth, _y + _outerHeight);
		_ctx.lineTo(_x, _y + _outerHeight);
		_ctx.lineTo(_x, _y);
		_ctx.closePath();

		// polygon2 --- usually hole,must be counter-clockwise
		_ctx.moveTo(_centerx - _innerW2, _centery - _innerH2);
		_ctx.lineTo(_centerx - _innerW2, _centery + _innerH2);
		_ctx.lineTo(_centerx + _innerW2, _centery + _innerH2);
		_ctx.lineTo(_centerx + _innerW2, _centery - _innerH2);
		_ctx.lineTo(_centerx - _innerW2, _centery - _innerH2);
		_ctx.closePath();

		//  add as many holes as you want
		if (_color != null) {
			_ctx.fillColourRGB(_color, _alpha);
			_ctx.fill();
		}

		if (_colorstoke != null) {
			_ctx.strokeColourRGB(_colorstoke);
			_ctx.lineWidth = 1;
			_ctx.stroke();
		}

		// _ctx.fillStyle = "#FF0000";
		// _ctx.strokeStyle = "rgba(0.5,0.5,0.5,0.5)";

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

	function get__outerWidth():Float {
		return _outerWidth;
	}

	function set__outerWidth(value:Float):Float {
		return _outerWidth = value;
	}

	function get__outerHeight():Float {
		return _outerHeight;
	}

	function set__outerHeight(value:Float):Float {
		return _outerHeight = value;
	}

	function get__innerWidth():Float {
		return _innerWidth;
	}

	function set__innerWidth(value:Float):Float {
		return _innerWidth = value;
	}

	function get__innerHeight():Float {
		return _innerHeight;
	}

	function set__innerHeight(value:Float):Float {
		return _innerHeight = value;
	}

	function get__centered():Bool {
		return _centered;
	}

	function set__centered(value:Bool):Bool {
		return _centered = value;
	}

	function get__alpha():Float {
		return _alpha;
	}

	function set__alpha(value:Float):Float {
		return _alpha = value;
	}

	// ____________________________________ tostring ____________________________________

	public function toString() {
		// return haxe.Json.stringify(this);
		return ('Masks: ' + haxe.Json.parse(haxe.Json.stringify(this)));
	}
}
