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

class Text {
	// are always set
	private var _ctx:CanvasRenderingContext2D;
	private var _text:String;

	// defaults
	@:isVar public var _x(get, set):Float = 100;
	@:isVar public var _y(get, set):Float = 100;
	@:isVar public var _radius(get, set):Float = 100;
	@:isVar public var _alpha(get, set):Float = 1; // 0 -> 1
	@:isVar public var _rotate(get, set):Int = 0; // weird for circles ???
	// type related
	@:isVar public var _size(get, set):Int;

	private var _font:String = 'Arial'; // italic small-caps bold 12px aria
	// https://www.w3schools.com/tags/canvas_textalign.asp
	private var _textAlign:String = 'left'; // center|end|left|right|start"
	// https://www.w3schools.com/tags/canvas_textbaseline.asp
	private var _textBaseline:String = 'alphabetic'; // alphabetic|top|hanging|middle|ideographic|bottom
	// Color
	private var _color:RGB;
	private var _colorstoke:RGB;
	private var _lineArray:Array<String>;

	@:isVar public var _gradient(get, set):js.html.CanvasGradient;
	@:isVar public var _leading(get, set):Int;

	// ____________________________________ constructor ____________________________________
	public function new(ctx:CanvasRenderingContext2D, text:String) {
		this._ctx = ctx;
		this._text = text;
	}

	/**
	 * var text = Text.create (ctx, 'Matthijs Kamstra aka [mck]').draw();
	 *
	 * @param ctx
	 * @param text
	 * @return Text
	 */
	static inline public function create(ctx:CanvasRenderingContext2D, text:String):Text {
		var Text = new Text(ctx, text);
		return Text;
	}

	// ____________________________________ properties ____________________________________

	inline public function text(text:String):Text {
		this._text = text;
		return this;
	}

	inline public function x(x:Float):Text {
		this._x = x;
		return this;
	}

	inline public function y(y:Float):Text {
		this._y = y;
		return this;
	}

	inline public function pos(x:Float, y:Float):Text {
		this._x = x;
		this._y = y;
		return this;
	}

	inline public function font(font:String):Text {
		this._font = font.replace(';', '').replace('+', ' ');
		return this;
	}

	inline public function size(px:Int):Text {
		this._size = px;
		if (_leading == null)
			_leading = px;
		return this;
	}

	inline public function leading(px:Int):Text {
		this._leading = px;
		return this;
	}

	inline public function textAlign(pos:String):Text {
		this._textAlign = pos; // left/right/center
		return this;
	}

	inline public function leftAlign():Text {
		this._textAlign = 'left'; // left/right/center
		return this;
	}

	inline public function rightAlign():Text {
		this._textAlign = 'right'; // left/right/center
		return this;
	}

	inline public function centerAlign():Text {
		this._textAlign = 'center'; // left/right/center
		return this;
	}

	inline public function topBaseline():Text {
		this._textBaseline = 'top'; // top/middle/bottom
		return this;
	}

	inline public function middleBaseline():Text {
		this._textBaseline = 'middle'; // top/middle/bottom
		return this;
	}

	inline public function bottomBaseline():Text {
		this._textBaseline = 'bottom'; // top/middle/bottom
		return this;
	}

	inline public function textBaseline(pos:String):Text {
		this._textBaseline = pos; // top/middle/bottom
		return this;
	}

	inline public function rotate(degree:Int):Text {
		this._rotate = degree;
		return this;
	}

	inline public function rotateLeft():Text {
		this._rotate = -90;
		return this;
	}

	inline public function rotateRight():Text {
		this._rotate = 90;
		return this;
	}

	inline public function rotateDown():Text {
		this._rotate = 180;
		return this;
	}

	inline public function color(value:RGB, ?alpha:Float = 1):Text {
		this._color = value;
		this._alpha = clamp(alpha, 0, 1); // a value r should be between 0 and 1
		return this;
	}

	inline public function alpha(alpha:Float):Text {
		this._alpha = clamp(alpha, 0, 1); // a value r should be between 0 and 1
		// this._alpha = alpha; // a value r should be between 0 and 1
		return this;
	}

	inline public function visible(isVisible:Bool):Text {
		if (isVisible) {
			alpha(1);
		} else {
			alpha(0);
		}
		return this;
	}

	inline public function draw():Text {
		var isLines = false;
		// draw to convast
		_ctx.save(); // save current state
		// split in lines
		if (_text.indexOf('\n') != -1) {
			_lineArray = _text.split('\n');
			isLines = true;
		}
		// remembor previous color
		var previousColor = _ctx.fillStyle;
		// check if color is set
		if (_color != null) {
			_ctx.fillColourRGB(_color, this._alpha);
		} else {
			_ctx.fillColourRGB(cc.util.ColorUtil.hex2RGB(previousColor), this._alpha);
		}
		_ctx.font = '${_size}px ${_font}';
		_ctx.textAlign = _textAlign;
		_ctx.textBaseline = _textBaseline;

		// move canvas and rotate
		_ctx.translate(_x, _y);
		_ctx.rotate(radians(_rotate));
		if (!isLines) {
			// print text
			_ctx.fillText(_text, 0, 0);
		} else {
			for (i in 0..._lineArray.length) {
				var line = _lineArray[i];
				_ctx.fillText(line, 0, i * _leading);
			}
		}
		// restore canvas to previous position
		_ctx.restore();

		// restore previous color?
		_ctx.fillStyle = previousColor;

		return this;
	}

	// public static function text(, x:Float, y:Float, css:String, ?size:Int = 20) {
	// 	ctx.font = '${size}px ${css.replace(';', '')}';
	// 	// seems to break something if css has `;`
	// 	ctx.textAlign = "left"; // center / right
	// 	ctx.font = '100px Miso';
	// 	ctx.textAlign = 'center';
	// 	ctx.textBaseline = 'middle';
	// 	ctx.fillText(text, x, y);
	// }
	// TODO:
	//		2 fonts in one <link>
	// 		resize window and not end up with multiple <links>
	//		chaining? `ctx.embedFillText().color().multiline()`
	public static function fillText(ctx:CanvasRenderingContext2D, text:String, x:Float, y:Float, css:String, ?size:Int = 20) {
		ctx.font = '${size}px ${css.replace(';', '')}';
		// seems to break something if css has `;`
		ctx.textAlign = "left";
		ctx.fillText(text, x, y);
	}

	// function lines () {
	// 	// important to have a example text in the canvas, otherwise the measurement don't work
	// 	// important to have the font loaded
	// 	ctx.fillStyle = getColourObj(_color4);
	// 	Text.fillText(ctx, text, w / 2, -h, "'Oswald', sans-serif;", _fontSize);
	// 	// split text up into string/lines
	// 	var lines:Array<String> = TextUtil.getLines(ctx, text, square - (2 * _padding));
	// 	for (i in 0...lines.length) {
	// 		var line = lines[i];
	// 		Text.fillText(ctx, line, _padding, _paddingTop + ((i + 1) * _lineHeight), "'Oswald', sans-serif;", _fontSize);
	// 	}
	// }

	/**
	 * make sure to use Google fonts for this
	 * @param ctx
	 * @param text
	 * @param x
	 * @param y
	 * @param css
	 * @param size
	 */
	public static function centerFillText(ctx:CanvasRenderingContext2D, text:String, x:Float, y:Float, css:String, ?size:Int = 20) {
		ctx.font = '${size}px ${css.replace(';', '')}';
		// seems to break something if css has `;`
		ctx.textAlign = "center";
		ctx.fillText(text, x, y);

		// trace( text, x, y, css, size);
	}

	/**
	 * [Description]
	 *
	 * @exampe
	 * 		Text.embedGoogleFont('Press+Start+2P', onEmbedHandler);
	 *
	 * @param family	name given after `...css?family=` (example: Press+Start+2P)
	 * @param callback
	 * @param callbackArray
	 */
	public static function embedGoogleFont(family:String, ?callback:Dynamic, ?callbackArray:Array<Dynamic>) {
		// trace('embedGoogleFont');
		var _id = 'embededGoogleFonts';
		var _url = 'https://fonts.googleapis.com/css?family=';
		var link:LinkElement = cast document.getElementById(_id);
		if (link != null) {
			var temp = link.href.replace(_url, '');
			family = temp + '|' + family;
		} else {
			link = document.createLinkElement();
		}
		if (callbackArray == null)
			callbackArray = [family];
		link.href = '${_url}${family}';
		link.rel = "stylesheet";
		link.id = _id;
		link.onload = function() {
			if (callback != null)
				Reflect.callMethod(callback, callback, callbackArray);
		}
		document.head.appendChild(link);
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

	function get__size():Int {
		return _size;
	}

	function set__size(value:Int):Int {
		return _size = value;
	}

	function get__leading():Int {
		return _leading;
	}

	function set__leading(value:Int):Int {
		return _leading = value;
	}

	// ____________________________________ tostring ____________________________________
	public function toString() {
		// return haxe.Json.stringify(this);
		return ('Text: ' + haxe.Json.parse(haxe.Json.stringify(this)));
	}
}
