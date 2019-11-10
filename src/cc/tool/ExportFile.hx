package cc.tool;

import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.Browser.*;
import js.Browser.window;
import cc.util.MathUtil;

using StringTools;

class ExportFile {
	/**
	 * probably only for webgl
	 * @param domElement
	 * @param isJpg
	 * @param fileName
	 */
	public static function downloadWebGLImage(domElement:CanvasElement, ?isJpg:Bool = false, ?fileName:String = "test") {
		var imgData:String;
		var ext = (isJpg) ? 'jpg' : 'png';
		try {
			// imgData = domElement.toDataURL();
			var strDownloadMime = "image/octet-stream";
			var strMime = "image/jpeg";
			imgData = domElement.toDataURL(strMime);
			console.log(imgData);

			ExportFile.saveFile(imgData.replace(strMime, strDownloadMime), fileName + '.${ext}');
		} catch (e:Dynamic) {
			console.log("Browser does not support taking screenshot of 3d context");
			return;
		}
	}

	public static function saveFile(strData:String, fileName:String) {
		var link = document.createAnchorElement();
		document.body.appendChild(link); // Firefox requires the link to be in the body
		link.href = strData;
		link.download = fileName;
		link.click();
		document.body.removeChild(link); // remove the link when done
	}

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
	 * cc.tool.ExportFile.downloadTextFile("This is the content of my file :)", "hello.txt");
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
		var userAgent = untyped js.Browser.navigator.userAgent;
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
	 * @param ctx		canvas
	 * @param isJpg		is this a jpg or png
	 * @param fileName 	name of file without extension (example: `foobar`)
	 */
	public static function downloadImageBg(ctx:CanvasRenderingContext2D, ?isJpg:Bool = false, ?fileName:String) {
		var canvas = ctx.canvas;
		var ext = (isJpg) ? 'jpg' : 'png';

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
		var imageData = canvas.toDataURL("image/png");

		// clear the canvas
		ctx.clearRect(0, 0, w, h);

		// restore it with original / cached ImageData
		ctx.putImageData(data, 0, 0);

		// reset the globalCompositeOperation to what it was
		ctx.globalCompositeOperation = compositeOperation;

		var link = document.createAnchorElement();
		link.style.cssText = "display:none";
		link.download = fileName + '.${ext}';

		// trace(link.download);
		// not sure how to do this in Haxe, so untyped to the resque
		if (!untyped HTMLCanvasElement.prototype.toBlob) {
			trace('There is no blob');
			link.href = ctx.canvas.toDataURL((isJpg) ? 'image/jpeg' : '', 1);
			link.click();
			link.remove();
		} else {
			// https://developer.mozilla.org/en-US/docs/Web/API/HTMLCanvasElement/toBlob
			trace('Attack of the blob');
			ctx.canvas.toBlob(function(blob) {
				link.href = js.html.URL.createObjectURL(blob);
				link.click();
				link.remove();
			}, (isJpg) ? 'image/jpeg' : '', 1);
		}
		document.body.appendChild(link);
	}

	// ____________________________________ toString() ____________________________________

	function toString():String {
		return '[ExportFile]';
	}
}
