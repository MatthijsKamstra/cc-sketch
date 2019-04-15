package cc.tool.export;

import js.Browser.*;
import js.JSZip;

using StringTools;

class ExportZip extends ExportWrapperBase implements IExport {
	public static var isZipLoaded:Bool = false;
	public static var isFileLoaded:Bool = false;

	public function new() {
		super();
		// might not be bullit proof!!!
		embedScripts(onEmbedComplete);
	}

	// ____________________________________ public funcitions ____________________________________

	public function export(obj:ExportWrapper.ExportWrapperObj):Void {
		// trace(getMarkdown(obj));
		// trace(getBashConvert(obj));
		// trace(getBashConvertPng(obj));

		var startT = Date.now().getTime();

		if (obj.imageStringArray.length == 0) {
			trace('NO images created / use start() - ${(Date.now().getTime() - startT) / 1000}sec');
			return;
		}

		trace('Start creation zip file - ${(Date.now().getTime() - startT) / 1000}sec');
		var zip = new JSZip();
		zip.file('_${obj.filename}/README.MD', getMarkdown(obj));
		zip.file('_${obj.filename}/convert.sh', getBashConvert(obj));
		zip.file('_${obj.filename}/png.sh', getBashConvertPng(obj));
		for (i in 0...obj.imageStringArray.length) {
			if (_isDebug)
				trace('/${obj.imageStringArray.length}. add image to file');
			var img = obj.imageStringArray[i];
			zip.file('_${obj.filename}/sequence/image_${Std.string(i).lpad('0', 4)}.png', img, {base64: true});
		}
		trace('Generate zip file - ${(Date.now().getTime() - startT) / 1000}sec');

		// createProgressBar(); // create another progress over the old
		// out('generate zip');
		zip.generateAsync({type: "blob"}, function updateCallback(metadata) {
			if (_isDebug)
				console.log("progression: " + metadata.percent.toFixed(2) + " %");
			// progressGeneration(Std.parseFloat(metadata.percent.toFixed(2)));
			// if (metadata.currentFile) {
			// 	console.log("current file = " + metadata.currentFile);
			// }
			if (Reflect.isFunction(_onProgressHandler)) {
				Reflect.callMethod(_onProgressHandler, _onProgressHandler, [Std.parseFloat(metadata.percent.toFixed(2))]);
			}
		}).then(function(blob) { // 1) generate the zip file
			console.log('Save zip file complete - ${(Date.now().getTime() - startT) / 1000}sec');
			// out('zip is downloaded');
			untyped saveAs(blob, '_${obj.filename}_${obj.timestamp}.zip'); // 2) trigger the download

			if (Reflect.isFunction(_onExportComplete)) {
				// trace('xxxx');
				Reflect.callMethod(_onExportComplete, _onExportComplete, []);
			}

			// trace(settings());
		}, function(err) {
			console.log(err);
		});
	}

	// ____________________________________ inject script into page ____________________________________

	/**
	 * embedScripts(onEmbedComplete);
	 *
	 * @param callback
	 * @param callbackArray
	 */
	public function embedScripts(?callback:Dynamic, ?callbackArray:String->Void) {
		if (!Embed.check('jszip')) {
			Embed.script('jszip', 'https://cdnjs.cloudflare.com/ajax/libs/jszip/3.2.0/jszip.min.js', onLoadComplete, ['jszip', callback, callbackArray]);
		}
		if (!Embed.check('jsfilesaver')) {
			Embed.script('jsfilesaver', 'https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js', onLoadComplete,
				['jsfilesaver', callback, callbackArray]);
		}
	}

	function onLoadComplete(str:String, ?callback:Dynamic, ?callbackArray:Array<Dynamic>) {
		// trace(str, callback, callbackArray);
		switch (str) {
			case 'jsfilesaver':
				// trace('jsfilesaver');
				isFileLoaded = true;
			case 'jszip':
				// trace('jszip');
				isZipLoaded = true;
			default:
				trace("case '" + str + "': trace ('" + str + "');");
		}
		if (isFileLoaded && isZipLoaded) {
			// trace(isFileLoaded, isZipLoaded);
			Reflect.callMethod(callback, callback, ['JsZip and jsFilesaver are embedded and loaded']);
		}
	}

	function onEmbedComplete(?value:String) {
		console.log('${toString()} - ${value}');
	}

	// ____________________________________ toString() ____________________________________

	override public function toString():String {
		return '[Export via Zip]';
	}
}
