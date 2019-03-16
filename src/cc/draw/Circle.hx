package cc.draw;

import js.html.CanvasRenderingContext2D;
import js.html.*;
import js.Browser.document;
import js.Browser.window;
// import cc.Global.*;
import cc.util.ColorUtil.RGB;
import cc.util.MathUtil.*;
import cc.draw.Gradient;

using cc.CanvasTools;
using StringTools;

class Circle {
	// are always set
	private var _ctx:CanvasRenderingContext2D;

	// defaults
	@:isVar public var _x(get, set):Float = 100;
	@:isVar public var _y(get, set):Float = 100;
	@:isVar public var _radius(get, set):Float = 100;

	private var _color:RGB;
	private var _colorstoke:RGB;
	private var _gradient:js.html.CanvasGradient;
	private var _alpha:Float = 1;
	private var _rotate:Int = 0;

	public function new(ctx:CanvasRenderingContext2D) {
		this._ctx = ctx;
	}

	/**
	 * var text = Text.create (ctx, 'Matthijs Kamstra aka [mck]').draw();
	 *
	 * @param ctx
	 * @param text
	 * @return Text
	 */
	static inline public function create(ctx:CanvasRenderingContext2D):Circle {
		var c = new Circle(ctx);
		return c;
	}

	// ____________________________________ properties ____________________________________

	inline public function x(x:Float):Circle {
		this._x = x;
		return this;
	}

	inline public function y(y:Float):Circle {
		this._y = y;
		return this;
	}

	inline public function pos(x:Float, y:Float):Circle {
		this._x = x;
		this._y = y;
		return this;
	}

	// inline public function size(px:Int):Circle {
	// 	this._size = px;
	// 	return this;
	// }

	inline public function radius(px:Int):Circle {
		this._radius = px;
		return this;
	}

	inline public function rotate(degree:Int):Circle {
		this._rotate = degree;
		return this;
	}

	inline public function rotateLeft():Circle {
		this._rotate = -90;
		return this;
	}

	inline public function rotateRight():Circle {
		this._rotate = 90;
		return this;
	}

	inline public function rotateDown():Circle {
		this._rotate = 180;
		return this;
	}

	inline public function color(value:RGB):Circle {
		this._color = value;
		return this;
	}

	inline public function gradient(value:js.html.CanvasGradient):Circle {
		this._gradient = value;
		return this;
	}

	inline public function fill(value:RGB):Circle {
		this._color = value;
		return this;
	}

	inline public function stroke(value:RGB):Circle {
		this._colorstoke = value;
		return this;
	}

	inline public function alpha(value:Float):Circle {
		this._alpha = value;
		return this;
	}

	inline public function draw():Circle {
		// draw to convast
		_ctx.save(); // save current state

		var previousColor = _ctx.fillStyle;
		// check if color is set
		if (_color != null && _gradient == null) {
			_ctx.fillColourRGB(_color, _alpha);
		}

		if (_gradient != null) {
			_ctx.fillStyle = _gradient;
		}
		this.circleFill(_ctx, _x, _y, _radius);

		// move canvas and rotate
		// _ctx.translate(_x, _y);
		// _ctx.rotate(radians(_rotate) );
		// print text
		// _ctx.fillText(_text, 0, 0);

		// restore canvas to previous position
		_ctx.restore();

		// restore previous color?
		_ctx.fillStyle = previousColor;

		return this;
	}

	/**
	 * circles
	 */
	function makeCircle(ctx:CanvasRenderingContext2D, x:Float, y:Float, radius:Float) {
		ctx.beginPath();
		ctx.arc(x, y, radius, 0, Math.PI * 2, true);
	};

	function circleFillStroke(ctx:CanvasRenderingContext2D, x:Float, y:Float, radius:Float) {
		makeCircle(ctx, x, y, radius);
		ctx.fill();
		ctx.stroke();
		ctx.closePath();
	};

	function circleFill(ctx:CanvasRenderingContext2D, x:Float, y:Float, radius:Float) {
		makeCircle(ctx, x, y, radius);
		ctx.fill();
		ctx.closePath();
	};

	function circleStroke(ctx:CanvasRenderingContext2D, x:Float, y:Float, radius:Float) {
		makeCircle(ctx, x, y, radius);
		ctx.stroke();
		ctx.closePath();
	};

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

	function get__radius():Float {
		return _radius;
	}

	function set__radius(value:Float):Float {
		return _radius = value;
	}

	// ____________________________________ tostring ____________________________________
	public function toString() {
		// return '{
		// 	_x: ${_x},
		// 	_y: ${_y},
		// 	_color: ${_color},
		// 	_radius: ${_radius},
		// }';
		// return haxe.Json.stringify(this);
		return ('Circle: ' + haxe.Json.parse(haxe.Json.stringify(this)));
	}
}
