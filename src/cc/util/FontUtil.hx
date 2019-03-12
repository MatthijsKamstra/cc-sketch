package cc.util;

import js.html.CanvasRenderingContext2D;
import js.html.*;
import js.Browser.document;
import js.Browser.window;

// import cc.Global.*;
import cc.util.ColorUtil.RGB;
import cc.util.MathUtil.*;

using cc.CanvasTools;
using StringTools;

class FontUtil {

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

	public function new(ctx:CanvasRenderingContext2D, text:String) {
		this._ctx = ctx;
		this._text = text;
	}

	/**
	 * var text = FontUtil.create (ctx, 'Matthijs Kamstra aka [mck]').draw();
	 *
	 * @param ctx
	 * @param text
	 * @return FontUtil
	 */
	static inline public function create(ctx:CanvasRenderingContext2D, text:String):FontUtil {
		var FontUtil = new FontUtil(ctx, text);
		return FontUtil;
	}

	// ____________________________________ properties ____________________________________

	inline public function text(text:String):FontUtil {
		this._text = text;
		return this;
	}
	inline public function x(x:Float):FontUtil {
		this._x = x;
		return this;
	}
	inline public function y(y:Float):FontUtil {
		this._y = y;
		return this;
	}
	inline public function pos(x:Float,y:Float):FontUtil {
		this._x = x;
		this._y = y;
		return this;
	}
	inline public function font(font:String):FontUtil {
		this._font = font.replace(';','');
		return this;
	}
	inline public function size(px:Int):FontUtil {
		this._size = px;
		return this;
	}
	inline public function textAlign(pos:String):FontUtil {
		this._textAlign = pos; // left/right/center
		return this;
	}
	inline public function leftAlign():FontUtil {
		this._textAlign = 'left'; // left/right/center
		return this;
	}
	inline public function rightAlign():FontUtil {
		this._textAlign = 'right'; // left/right/center
		return this;
	}
	inline public function centerAlign():FontUtil {
		this._textAlign = 'center'; // left/right/center
		return this;
	}
	inline public function topBaseline():FontUtil {
		this._textBaseline = 'top'; // top/middle/bottom
		return this;
	}
	inline public function middleBaseline():FontUtil {
		this._textBaseline = 'middle'; // top/middle/bottom
		return this;
	}
	inline public function bottomBaseline():FontUtil {
		this._textBaseline = 'bottom'; // top/middle/bottom
		return this;
	}
	inline public function textBaseline(pos:String):FontUtil {
		this._textBaseline = pos; // top/middle/bottom
		return this;
	}
	inline public function rotate(degree:Int):FontUtil {
		this._rotate = degree;
		return this;
	}
	inline public function rotateLeft():FontUtil {
		this._rotate = -90;
		return this;
	}
	inline public function rotateRight():FontUtil {
		this._rotate = 90;
		return this;
	}
	inline public function rotateDown():FontUtil {
		this._rotate = 180;
		return this;
	}
	inline public function color(value:RGB):FontUtil {
		this._color = value;
		return this;
	}
	inline public function draw():FontUtil {
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
	 * 		FontUtil.embedGoogleFont('Press+Start+2P', onEmbedHandler);
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
}
