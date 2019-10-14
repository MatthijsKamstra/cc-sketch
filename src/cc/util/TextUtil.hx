package cc.util;

import js.html.CanvasRenderingContext2D;
import cc.util.MathUtil;
import cc.util.MathUtil.*;

using StringTools;

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
	 * @example
	 *
	 * 		var lines:Array<String> = TextUtil.getLines(ctx, text, square - (2 * _padding));
	 * 		for (i in 0...lines.length) {
	 * 			var line = lines[i];
	 * 		}
	 *
	 * @param ctx
	 * @param text
	 * @param maxWidth
	 */
	public static function getLines(ctx:CanvasRenderingContext2D, text:String, maxWidth:Float):Array<String> {
		// trace('$text, $maxWidth');
		// [mck] make sure that all lines are with \n included
		text = text.replace('\n', " \n ").replace("  ", " "); // make sure `\n` is seperated from the rest of the words
		var words:Array<String> = text.split(" ");
		var lines:Array<String> = [];
		var currentLine = words[0];

		for (i in 1...words.length) {
			// for (var i = 1; i < words.length; i++) {
			var word = words[i];
			if (word == "\n") {
				lines.push(currentLine.trim()); // Removes leading and trailing space characters
				currentLine = "";
				continue;
			}
			var width = ctx.measureText(currentLine + " " + word).width;
			if (width < maxWidth) {
				currentLine += " " + word;
			} else {
				lines.push(currentLine.trim()); // Removes leading and trailing space characters
				if(word == " "){
					currentLine = "";
				} else {
					currentLine = word;
				}

			}
		}
		lines.push(currentLine.trim());
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

	static public function drawTextAlongArc4(ctx:CanvasRenderingContext2D, str:String, centerX:Float, centerY:Float, radius:Float, ?startDegree:Int = -90) {
		// monotype
		var monoW = ctx.measureText(" ").width;
		// chars
		var charArr = str.split('');
		ctx.save();
		var angle = 0.0;
		for (i in 0...charArr.length) {
			radius -= (0.15 + (i * 0.0005));
			var a = monoW;
			var b = radius;
			var c = radius;
			var cosa = (Math.pow(b, 2) + Math.pow(c, 2) - Math.pow(a, 2)) / (2 * b * c);
			var pAngle = degrees(Math.acos(cosa));
			var _char = charArr[i];
			angle = startDegree + (i * (pAngle));
			var xpos = centerX + Math.cos(radians(angle)) * radius;
			var ypos = centerY + Math.sin(radians(angle)) * radius;

			// radius: 200 / angle: 3.95
			// radius: 300 / angle: 2.45
			// trace('char: $_char, xpos: $xpos, ypos: $ypos, angle: $angle, ${radians(angle)}');

			ctx.save();
			ctx.translate(xpos, ypos);
			ctx.rotate(radians(angle + 90));
			// ctx.translate(0, -1 * radius);
			ctx.fillText(_char, 0, 0);
			ctx.restore();
		}
		ctx.restore();
	}

	static public function drawTextAlongArc3(ctx:CanvasRenderingContext2D, str:String, centerX:Float, centerY:Float, radius:Int) {
		var charArr = str.split('');

		ctx.save();
		// ctx.translate(centerX, centerY);
		// ctx.rotate(-1 * angle / 2);
		// ctx.rotate(-1 * (angle / charArr.length) / 2);

		// sh.angle += sh.speed;

		var angle = 0;
		// for (var n = 0; n < str.length; n++) {
		for (i in 0...charArr.length) {
			var _char = charArr[i];
			angle = i;

			// plot the balls x to cos and y to sin
			var xpos = centerX + Math.cos(radians(angle)) * radius;
			var ypos = centerY + Math.sin(radians(angle)) * radius;
			trace(_char, i, xpos, ypos);
			ctx.translate(xpos, ypos);
			ctx.rotate(angle / charArr.length);
			// ctx.save();
			// ctx.translate(0, -1 * radius);
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
