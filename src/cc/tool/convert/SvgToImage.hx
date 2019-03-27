package cc.tool.convert;

import js.html.Image;
import js.Browser.window;

class SvgToImage {
	public function new():Void {}

	static public function convert(svg:String, callback:Dynamic) {
		// create the image used
		var svgImage = new Image();
		svgImage.onload = function() {
			trace('base64 square');
			trace('w: ' + svgImage.width);
			trace('h: ' + svgImage.height);
			Reflect.callMethod(callback, callback, [svgImage]);
		}

		// get svg data (from the dom)
		// var xml = new XMLSerializer().serializeToString(svg);

		// make it base64
		var svg64 = window.btoa(svg);
		var b64Start = 'data:image/svg+xml;base64,';

		// prepend a "header"
		var image64 = b64Start + svg64;

		// set it as the source of the img element
		svgImage.src = image64;

		// draw the image onto the canvas
		// ctx.drawImage(img, 10, 10);
	}
}
