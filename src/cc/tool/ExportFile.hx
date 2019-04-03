package cc.tool;

import js.html.CanvasRenderingContext2D;
import js.Browser.*;
import js.Browser.window;
import cc.util.MathUtil;

using StringTools;

class ExportFile {
	/**
	 * [Description]
	 * @param ctx
	 * @param isJpg
	 * @param fileName
	 */
	public static function downloadImage(ctx:CanvasRenderingContext2D, ?isJpg:Bool = false, ?fileName:String) {
		if (fileName == null) {
			var hash = js.Browser.location.hash;
			hash = hash.replace('#', '').toLowerCase();
			if (hash == '')
				hash = 'image';
			fileName = '${hash}-${Date.now().getTime()}';
			// fileName = 'cc-art-${Date.now().getTime()}';
		}
		var link = document.createAnchorElement();
		link.href = ctx.canvas.toDataURL((isJpg) ? 'image/jpeg' : '', 1);
		link.download = fileName;
		link.click();
	}

	/**
	 * [Description]
	 * @param ctx
	 * @param isJpg
	 */
	public static function onBase64Handler(ctx:CanvasRenderingContext2D, ?isJpg:Bool = false) {
		var base64 = ctx.canvas.toDataURL((isJpg) ? 'image/jpeg' : '', 1);
		// var base64 = ctx.toDataURL(); // default png
		clipboard(base64);
	}

	/**
	 * Start file download.
	 * ExportUtil.downloadTextFile("This is the content of my file :)", "hello.txt");
	 *
	 * @param text
	 * @param fileName
	 */
	public static function downloadTextFile(text:String, ?fileName:String) {
		if (fileName == null)
			fileName = 'CC-txt-${Date.now().getTime()}.txt';

		var element = document.createElement('a');
		element.setAttribute('href', 'data:text/plain;charset=utf-8,' + untyped encodeURIComponent(text));
		element.setAttribute('download', fileName);

		element.style.display = 'none';
		document.body.appendChild(element);

		element.click();

		document.body.removeChild(element);
	}

	/**
	 * [Description]
	 * @example
	 * 			utils.Clipboard.copy('hello');
	 * @param text 	value you want to export (probably base64)
	 */
	public static function clipboard(text:String) {
		var win = 'Ctrl+C';
		var mac = 'Cmd+C';
		var copyCombo = win;
		var userAgent = js.Browser.navigator.userAgent;
		var ereg = new EReg("iPhone|iPod|iPad|Android|BlackBerry", "i");
		var ismac = ereg.match(userAgent);
		if (ismac)
			copyCombo = mac;
		window.prompt('Copy to clipboard: $copyCombo, Enter', text);
	}

	/**
	 * Returns contents of a canvas as a png based data url, with the specified background color
	 *
	 * just change the background to white... it really doesn't matter, when exporting a jpg
	 *
	 * @param ctx
	 * @param isJpg
	 * @param fileName
	 */
	public static function downloadImageBg(ctx:CanvasRenderingContext2D, ?isJpg:Bool = false, ?fileName:String) {
		var canvas = ctx.canvas;

		if (fileName == null) {
			var hash = js.Browser.location.hash;
			hash = hash.replace('#', '').toLowerCase();
			if (hash == '')
				hash = 'image';
			fileName = '${hash}-${Date.now().getTime()}';
			// fileName = 'cc-art-${Date.now().getTime()}';
		}

		// cache height and width
		var w = canvas.width;
		var h = canvas.height;

		// var ctx = canvas.getctx2d();

		var data;
		var compositeOperation:String;

		// get the current ImageData for the canvas.
		data = ctx.getImageData(0, 0, w, h);

		// store the current globalCompositeOperation
		compositeOperation = ctx.globalCompositeOperation;

		// set to draw behind current content
		ctx.globalCompositeOperation = "destination-over";

		// set background color
		ctx.fillStyle = '#ffffff';

		// draw background / rect on entire canvas
		ctx.fillRect(0, 0, w, h);

		// get the image data from the canvas
		// var imageData = canvas.toDataURL("image/png");

		// // clear the canvas
		// ctx.clearRect(0, 0, w, h);

		// // restore it with original / cached ImageData
		// ctx.putImageData(data, 0, 0);

		// // reset the globalCompositeOperation to what it was
		// ctx.globalCompositeOperation = compositeOperation;

		var link = document.createAnchorElement();
		link.href = ctx.canvas.toDataURL((isJpg) ? 'image/jpeg' : '', 1);
		link.download = fileName;
		link.click();
	}

	// ____________________________________ toString() ____________________________________

	function toString():String {
		return '[ExportFile]';
	}
}
