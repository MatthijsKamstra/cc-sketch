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
 * @example:
 * 		var gradient = cc.draw.Gradient.create(ctx).draw();
 * 		ctx.fillRect(0, 0, gradient.width, gradient.height);
 *
 * 		// try gradient circle
 * 		var circle = cc.draw.Circle.create(ctx).radius(20).pos(55, 55).radius(20);
 *		var grad = cc.draw.Gradient.create(ctx).circle(circle).draw();
 *		circle.gradient(grad.get).draw();
 *		trace(circle.toString());
 *		trace(grad.toString());
 */
class Gradient {
	// are always set
	private var _ctx:CanvasRenderingContext2D;
	private var _x:Float = 0;
	private var _y:Float = 0;
	private var _width:Float = 100;
	private var _height:Float = 100;
	private var _startPoint:GradientObj = {x: 0, y: 0};
	private var _endPoint:GradientObj = {x: 100, y: 100};
	private var _get:js.html.CanvasGradient;
	private var _colorArray:Array<Dynamic>;
	private var _circle:cc.draw.Circle;
	private var _dir:String = 'l';

	// getter setter
	@:isVar public var _linear(get, set):Bool = true;
	@:isVar public var _radial(get, set):Bool = false;

	// /
	public function new(ctx:CanvasRenderingContext2D) {
		setDir(_dir);
		this._colorArray = [{stop: 0, color: "black"}, {stop: 1, color: "white"},];
		this._ctx = ctx;
	}

	/**
		* var Gradient = Gradient.create (ctx, 'Matthijs Kamstra aka [mck]').draw();
		*
		* @param ctx

		* @return Gradient
	 */
	static inline public function create(ctx:CanvasRenderingContext2D):Gradient {
		var c = new Gradient(ctx);
		return c;
	}

	// ____________________________________ properties ____________________________________
	inline public function x(x:Float):Gradient {
		this._x = x;
		return this;
	}

	inline public function y(y:Float):Gradient {
		this._y = y;
		return this;
	}

	inline public function pos(x:Float, y:Float):Gradient {
		this._x = x;
		this._y = y;
		return this;
	}

	inline public function size(w:Float, h:Float):Gradient {
		this._width = w;
		this._height = h;
		return this;
	}

	inline public function linear():Gradient {
		this._linear = true;
		this._radial = false;
		return this;
	}

	inline public function radial():Gradient {
		this._linear = false;
		this._radial = true;
		return this;
	}

	/**
	 * attach the values of cc.draw.Circle
	 *
	 * @param circle
	 * @return Gradient
	 */
	inline public function circle(circle:cc.draw.Circle):Gradient {
		this._circle = circle;
		trace(circle.toString());
		this._x = (circle._x - circle._radius * 1);
		this._y = (circle._y - circle._radius * 1);
		this._width = circle._radius * 2;
		this._height = circle._radius * 2;
		return this;
	}

	inline public function left():Gradient {
		setDir('l');
		return this;
	}

	inline public function right():Gradient {
		setDir('r');
		return this;
	}

	inline public function top():Gradient {
		setDir('t');
		return this;
	}

	inline public function bottom():Gradient {
		setDir('b');
		return this;
	}

	inline public function direction(startPoint:GradientObj, endPoint:GradientObj):Gradient {
		this._startPoint = startPoint;
		this._endPoint = endPoint;
		return this;
	}

	/**
	 * add colors, not clever right now. Just send a string for now
	 * @param stop value between 0 and 1
	 * @param color
	 * @return inline public function draw():Gradient
	 */
	inline public function color(stop:Float, color:String):Gradient {
		stop = clamp(stop, 0, 1);
		this._colorArray.push({stop: stop, color: color});
		return this;
	}

	function setDir(dir:String) {
		this._dir = dir;
		switch (dir) {
			case 'l':
				this._startPoint = {x: _x, y: _y};
				this._endPoint = {x: _x + _width, y: _y};
			case 'r':
				this._startPoint = {x: _x + _width, y: _y};
				this._endPoint = {x: _x, y: _y};
			case 't':
				this._startPoint = {x: _x, y: _y};
				this._endPoint = {x: _x, y: _y + _height};
			case 'b':
				this._startPoint = {x: _x, y: _y + _height};
				this._endPoint = {x: _x, y: _y};
			default:
				this._startPoint = {x: _x, y: _y};
				this._endPoint = {x: _x + _width, y: _y};
				trace("case '" + dir + "': trace ('" + dir + "');");
		}
	}

	inline public function draw():Gradient {
		setDir(this._dir);
		if (_linear) {
			_get = _ctx.createLinearGradient(_startPoint.x, _startPoint.y, _endPoint.x, _endPoint.y);
		} else {
			trace('WIP');
			// _get = _ctx.createRadialGradient(_startPoint.x, _startPoint.y, _endPoint.x, _endPoint.y);
		}
		for (i in 0..._colorArray.length) {
			var _c = _colorArray[i];
			_get.addColorStop(_c.stop, _c.color);
			// trace('stop: ${_c.stop}, color; ${_c.color}');
		}
		// _get.addColorStop(0, "black");
		// _get.addColorStop(1, "white");
		_ctx.fillStyle = _get;
		return this;
	}

	// ____________________________________ getter setters ____________________________________
	public var width(get_width, set_width):Float;

	function get_width():Float {
		return _width;
	}

	function set_width(value:Float):Float {
		return _width = value;
	}

	public var height(get_height, set_height):Float;

	function get_height():Float {
		return _height;
	}

	function set_height(value:Float):Float {
		return _height = value;
	}

	public var get(get_get, null):js.html.CanvasGradient;

	function get_get():js.html.CanvasGradient {
		_get = _ctx.createLinearGradient(_startPoint.x, _startPoint.y, _endPoint.x, _endPoint.y);
		for (i in 0..._colorArray.length) {
			var _c = _colorArray[i];
			_get.addColorStop(_c.stop, _c.color);
			// trace('stop: ${_c.stop}, color; ${_c.color}');
		}
		// _get.addColorStop(0, "black");
		// _get.addColorStop(1, "white");
		_ctx.fillStyle = _get;
		return _get;
	}

	public var xpos(get_xpos, null):Float;

	function get_xpos():Float {
		return _x;
	}

	public var ypos(get_ypos, null):Float;

	function get_ypos():Float {
		return _y;
	}

	function get__linear():Bool {
		return _linear;
	}

	function set__linear(value:Bool):Bool {
		return _linear = value;
	}

	function get__radial():Bool {
		return _radial;
	}

	function set__radial(value:Bool):Bool {
		return _radial = value;
	}

	// ____________________________________ tostring ____________________________________
	public function toString() {
		// return '{
		// 	_x: ${_x},
		// 	_y: ${_y},
		// 	_color: ${_color},
		// 	_radius: ${_radius},
		// }';
		return ('Gradient: ' + haxe.Json.parse(haxe.Json.stringify(this)));
	}
}

typedef GradientObj = {
	var x:Float; // The x-coordinate of the starting circle of the gradient
	var y:Float; // The y-coordinate of the starting circle of the gradient
	@:optional var r:Float; // The radius of the starting circle
};
