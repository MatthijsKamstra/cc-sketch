package cc.util;

import js.html.CanvasRenderingContext2D;

class TextUtil {
	public function new() {
		// your code
	}

	/**
		*
		* 		// important to have a example text in the canvas, otherwise the measurement don't work
				// important to have the font loaded

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
}
