package cc.util;

import js.html.CanvasRenderingContext2D;
import cc.util.MathUtil;

class TextUtil {
	public function new() {
		// your code
	}

	/**
	 *
	 * calculate the with of the characters, and create an array of words
	 *
	 * Note:
	 * 	- important to have a example text in the canvas, otherwise the measurement don't work
	 * 	- important to have the font loaded
	 *
	 * @source	 https://stackoverflow.com/questions/2936112/text-wrap-in-a-canvas-element
	 *
	 * @param ctx
	 * @param text
	 * @param maxWidth
	 */
	public static function getLines(ctx:CanvasRenderingContext2D, text:String, maxWidth:Float):Array<String> {
		// trace('$text, $maxWidth');
		var words:Array<String> = text.split(" ");
		var lines:Array<String> = [];
		var currentLine = words[0];

		for (i in 1...words.length) {
			// for (var i = 1; i < words.length; i++) {
			var word = words[i];
			var width = ctx.measureText(currentLine + " " + word).width;
			if (width < maxWidth) {
				currentLine += " " + word;
			} else {
				lines.push(currentLine);
				currentLine = word;
			}
		}
		lines.push(currentLine);
		return lines;
	}

	/**
		*
		* ctx.textAlign = "center";
		* ctx.textBaseline = "bottom";
		* ctx.font = '20px Source Code Pro';
		* TextUtil.drawTextAlongArc(ctx, "Hier moet iets staan dat de moeite waard is", centerX, centerY, radius, angle);

		* @param ctx
		* @param str
		* @param centerX
		* @param centerY
		* @param radius
		* @param angle
	 */
	static public function drawTextAlongArc(ctx:CanvasRenderingContext2D, str:String, centerX:Float, centerY:Float, radius:Int, angle:Float) {
		var charArr = str.split('');

		ctx.save();
		ctx.translate(centerX, centerY);
		ctx.rotate(-1 * angle / 2);
		ctx.rotate(-1 * (angle / charArr.length) / 2);

		// for (var n = 0; n < str.length; n++) {
		for (i in 0...charArr.length) {
			var _char = charArr[i];
			ctx.rotate(angle / charArr.length);
			ctx.save();
			ctx.translate(0, -1 * radius);
			ctx.fillText(_char, 0, 0);
			ctx.restore();
		}
		ctx.restore();
	}

	static public function drawTextAlongArc2(ctx:CanvasRenderingContext2D, str:String, centerX:Float, centerY:Float, radius:Int) {
		var charArr = str.split('');

		// monotype
		var width = ctx.measureText(" ").width;
		// trace(width); // 12px

		// trace(ctx.measureText("1").width);
		// trace(ctx.measureText("x").width);
		// trace(ctx.measureText("w").width);
		// trace(ctx.measureText(" ").width);
		// calculate some characters size to have an idea what the spacing is.§

		ctx.save();
		ctx.translate(centerX, centerY);

		// var _angle = 0.1;

		var _angle = 1.0;

		// for (var n = 0; n < str.length; n++) {
		for (i in 0...charArr.length) {
			var _char = charArr[i];

			// trace(i);
			var _rotation = MathUtil.radians(_angle);
			ctx.rotate(_angle * Math.PI / 360);
			// ctx.rotate(_rotation);

			trace('$i // _char = ${_char} : _angle: ${_angle} - _rotation: ${_rotation}');
			// ctx.rotate(MathUtil.radians(_angle * i));
			// ctx.rotate(MathUtil.radians(i + 1));
			ctx.save();
			ctx.translate(0, -1 * radius);
			ctx.fillText(_char, 0, 0);
			ctx.restore();

			_angle += 0.5;
		}
		ctx.restore();
	}
}
