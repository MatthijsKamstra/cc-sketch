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
	private var _text:String;
	// defaults
	private var _x:Float = 100;
	private var _y:Float = 100;
	private var _size:Int = 100;
	private var _color:RGB;
	private var _rotate:Int = 0;
	private var _font:String = 'Arial'; // italic small-caps bold 12px aria
	// https://www.w3schools.com/tags/canvas_textalign.asp
	private var _textAlign:String = 'left'; // center|end|left|right|start"
	// https://www.w3schools.com/tags/canvas_textbaseline.asp
	private var _textBaseline:String = 'alphabetic'; // alphabetic|top|hanging|middle|ideographic|bottom

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
		var rectangle = new Rectangle(ctx, text);
		return Rectangle;
	}

	// ____________________________________ properties ____________________________________

	inline public function text(text:String):Rectangle {
		this._text = text;
		return this;
	}
	inline public function x(x:Float):Rectangle {
		this._x = x;
		return this;
	}
	inline public function y(y:Float):Rectangle {
		this._y = y;
		return this;
	}
	inline public function pos(x:Float,y:Float):Rectangle {
		this._x = x;
		this._y = y;
		return this;
	}
	// inline public function font(font:String):Rectangle {
	// 	this._font = font;
	// 	return this;
	// }
	inline public function size(px:Int):Rectangle {
		this._size = px;
		return this;
	}
	inline public function textAlign(pos:String):Rectangle {
		this._textAlign = pos; // left/right/center
		return this;
	}
	inline public function leftAlign():Rectangle {
		this._textAlign = 'left'; // left/right/center
		return this;
	}
	inline public function rightAlign():Rectangle {
		this._textAlign = 'right'; // left/right/center
		return this;
	}
	inline public function centerAlign():Rectangle {
		this._textAlign = 'center'; // left/right/center
		return this;
	}
	inline public function topBaseline():Rectangle {
		this._textBaseline = 'top'; // top/middle/bottom
		return this;
	}
	inline public function middleBaseline():Rectangle {
		this._textBaseline = 'middle'; // top/middle/bottom
		return this;
	}
	inline public function bottomBaseline():Rectangle {
		this._textBaseline = 'bottom'; // top/middle/bottom
		return this;
	}
	inline public function textBaseline(pos:String):Rectangle {
		this._textBaseline = pos; // top/middle/bottom
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
		this._stroke = value;
		return this;
	}
	inline public function draw():Rectangle {
		// draw to convast
		_ctx.save(); // save current state

		var previousColor = _ctx.fillStyle;
		// check if color is set
		if(_color != null){
			_ctx.fillColourRGB(_color);
		}
		_ctx.font = '${_size}px ${_font}';
		_ctx.textAlign = _textAlign;
		_ctx.textBaseline = _textBaseline;

		// move canvas and rotate
		_ctx.translate(_x, _y);
		_ctx.rotate(radians(_rotate) );
		// print text
		_ctx.fillText(_text, 0, 0);

		// restore canvas to previous position
		_ctx.restore();

		// restore previous color?
		_ctx.fillStyle = previousColor;

		return this;
	}

}