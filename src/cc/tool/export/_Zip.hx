package cc.tool.export;

import js.JSZip;
// settings
import quicksettings.QuickSettings;
//
import js.Browser.*;
import cc.tool.Embed;
// quick and dirty import for Haxe JavaScript
import js.Browser.*;
import js.html.*;

using StringTools;

/**
	* externs
	*
	* import js.JSZip;
	* import cc.tool.export.Zip;

	* https://github.com/abedev/npm/blob/master/src/npm/JSZip.hx
 */
/**
	import cc.tool.export.Zip;

	var zip:Zip;

	zip = new Zip(ctx, '${toString()}');
	zip.delay(60 * 3);
	zip.record(60 * 3);
	zip.delayInSeconds(0);
	zip.recordInSeconds(30);
	zip.menu(false);
	zip.embedScripts(onZipHandler);

	function onZipHandler(?value:String) {
		trace(value);
		zip.start();
	}

	// don't forget to hook into the pulse
	zip.pulse();

 */
class Zip {
	public static var isZipLoaded:Bool = false;
	public static var isFileLoaded:Bool = false;

	var isExportActive:Bool = false;
	//
	var panel1:QuickSettings;
	//
	var _delayCounter:Int = 0;
	var _recordCounter:Int = 0;
	var fps:Int = 60;

	@:isVar public var _delay(get, set):Int = 120; // (60*3) 60fps * 3sec
	@:isVar public var _record(get, set):Int = 600; // (60*10) 60fpx * 5sec
	@:isVar public var _ctx(get, set):js.html.CanvasRenderingContext2D;
	@:isVar public var description(get, set):String = '';
	@:isVar public var _isMenu(get, set):Bool = true;
	@:isVar public var _isDebug(get, set):Bool;

	var _filename:String;
	// timer
	var startT:Float;
	var endT:Float;
	// var imageArray:Array<js.html.ImageData> = [];
	var imageStringArray:Array<String> = [];
	var _onComplete:Dynamic;
	var _onCompleteParams:Array<Dynamic>;
	var _onRecordComplete:Dynamic;
	var _onRecordCompleteParams:Array<Dynamic>;
	var _onExportComplete:Dynamic;
	var _onExportCompleteParams:Array<Dynamic>;
	var progressBar:DivElement;

	public function new(ctx:CanvasRenderingContext2D, ?fileName:String) {
		createQuickSettings();
		createProgressBar();

		if (ctx == null)
			console.warn('This is not acceptable, I need a context!');

		this._filename = (fileName == null) ? toString() : fileName;
		this._ctx = ctx;
		out('Zip export ready');
	}

	function createQuickSettings() {
		panel1 = QuickSettings.create(10, 10, "Zip Exporter Settings")
			.addRange('delay in seconds', 0.0, 5.0, 2.0, 0.5, function(e) setDelay(e))
			.addRange('record in seconds', 0.0, 60.0, 2.0, 0.5, function(e) setRecord(e))

			.addButton('init recording', function(e) onClickHandler(e))
			.addText('feedback', 'x', function(e) {});
		// .addButton('start recording', function(e) onClickHandler(e))
		// .addButton('stop recording', function(e) onClickHandler(e))

		// .saveInLocalStorage('store-data-${toString()}');
	}

	function out(str:String) {
		if (panel1 == null)
			return;
		panel1.setValue('feedback', str);
	}

	function setDelay(e:Float) {
		out('delay in seconds: ' + Std.string(e));
		_delay = Math.round(fps * e);
	}

	function setRecord(e:Float) {
		out('recordinf in secondds: ' + Std.string(e));
		_record = Math.round(fps * e);
	}

	function onClickHandler(e:js.html.MouseEvent) {
		var input:js.html.InputElement = cast(e);

		switch (input.value) {
			case 'recording':
			case 'start recording':
			case 'init recording':
				trace('init recording');
				setDelay(panel1.getValue('delay in seconds'));
				setRecord(panel1.getValue('record in seconds'));
				start();
				trace(haxe.Json.parse(haxe.Json.stringify(this)));
			case 'stop recording':
				trace('stop recording');
				stop();
			default:
				trace("case '" + input.value + "': trace ('" + input.value + "');");
		}
	}

	function startExport() {
		out('${toString()} - start export - 0ms');
		trace(settings());
		startT = Date.now().getTime();
		isExportActive = true;
		imageStringArray = [];
		_delayCounter = 0;
		_recordCounter = 0;
		// imageArray.push(ctx.getImageData(0, 0, w, h));
		trace(toString() + ' - start export - 0ms');
		// trace(imageArray.length);
	}

	function stopExport() {
		endT = Date.now().getTime();
		isExportActive = false;
		out(toString() + ' - stop export - ${(endT - startT) / 1000}sec');
		trace(settings());

		if (Reflect.isFunction(_onComplete)) {
			var arr = (_onCompleteParams != null) ? _onCompleteParams : [];
			Reflect.callMethod(_onComplete, _onComplete, arr);
		}
		if (Reflect.isFunction(_onRecordComplete)) {
			var arr = (_onRecordCompleteParams != null) ? _onRecordCompleteParams : [];
			Reflect.callMethod(_onRecordComplete, _onRecordComplete, arr);
		}

		var timeStamp = endT;

		var md = '# ${toString()}

- Generated on: ${Date.now()}
- total images: ${imageStringArray.length}
- file name: `_${_filename}_${timeStamp}.zip`
- delay: ${_delay} frames (${_delay / 60} sec)
- record: ${_record} frames (${_record / 60} sec)

## Instagram

```
sketch.${_filename} :: ${description}


#codeart #coding #creativecode #generative #generativeArt
#minimalism #minimalist #minimal
#haxe #javascript #js #nodejs
#animation #illustration #graphicdesign
```

## convert

open terminal

```
sh convert.sh
```

## Folder structure

```
+ _${_filename}_${timeStamp}.zip
+ _${_filename}
	- convert.sh
	- README.MD
	+ sequence
		- image_${Std.string(0).lpad('0', 4)}.png
		- image_${Std.string(1).lpad('0', 4)}.png
		- ...
```
';

		var bash = '#!/bin/bash

echo \'Start convertions png sequence to mp4\'

ffmpeg -y -r 30 -i sequence/image_%04d.png -c:v libx264 -strict -2 -pix_fmt yuv420p -shortest -filter:v "setpts=0.5*PTS"  ${_filename}_output_30fps.mp4
# ffmpeg -y -r 30 -i sequence/image_%04d.png -c:v libx264 -strict -2 -pix_fmt yuv420p -shortest -filter:v "setpts=0.5*PTS"  sequence/_output_30fps.mp4

echo \'End convertions png sequence to mp4\'

';

		var bash2 = '
#!/bin/bash

echo \'Start remove transparancy from images sequence\'

cd sequence
mkdir output
for i in *.png; do
   convert "$$i" -background white -alpha remove output/"$$i"
   echo "$$i"
done

echo \'End remove transparancy from images sequence\'
echo \'Start convertions png sequence to mp4\'

ffmpeg -y -r 30 -i output/image_%04d.png -c:v libx264 -strict -2 -pix_fmt yuv420p -shortest -filter:v "setpts=0.5*PTS"  ../${_filename}_white_output_30fps.mp4

echo \'End convertions png sequence to mp4\'

';

		trace('Start creation zip file - ${(Date.now().getTime() - startT) / 1000}sec');
		var zip = new JSZip();
		zip.file('_${_filename}/README.MD', md);
		zip.file('_${_filename}/convert.sh', bash);
		zip.file('_${_filename}/png.sh', bash2);
		for (i in 0...imageStringArray.length) {
			if (_isDebug)
				trace('/${imageStringArray.length}. add image to file');
			var img = imageStringArray[i];
			zip.file('_${_filename}/sequence/image_${Std.string(i).lpad('0', 4)}.png', img, {base64: true});
		}
		trace('Generate zip file - ${(Date.now().getTime() - startT) / 1000}sec');

		createProgressBar(); // create another progress over the old
		out('generate zip');
		zip.generateAsync({type: "blob"}, function updateCallback(metadata) {
			if (_isDebug)
				console.log("progression: " + metadata.percent.toFixed(2) + " %");
			progressGeneration(Std.parseFloat(metadata.percent.toFixed(2)));
			// if (metadata.currentFile) {
			// 	console.log("current file = " + metadata.currentFile);
			// }
		}).then(function(blob) { // 1) generate the zip file
			console.log('Save zip file complete - ${(Date.now().getTime() - startT) / 1000}sec');
			out('zip is downloaded');
			untyped saveAs(blob, '_${_filename}_${timeStamp}.zip'); // 2) trigger the download

			if (Reflect.isFunction(_onExportComplete)) {
				var arr = (_onExportCompleteParams != null) ? _onExportCompleteParams : [];
				Reflect.callMethod(_onExportComplete, _onExportComplete, arr);
			}

			trace(settings());
		}, function(err) {
			console.log(err);
		});
	}

	function settings() {
		return {
			"filename": _filename,
			"delay": _delay,
			"record": _record,
			"delay_in_seconds": (_delay / 60),
			"record_in_seconds": (_record / 60),
		};
	}

	var progressBarHeight = 3;

	function createProgressBar(?percentage:Int = 10) {
		var body = document.querySelector('body');
		var div:DivElement = document.createDivElement();
		div.setAttribute("id", 'zip-progress');
		div.innerHTML = '<span style="display:none">$percentage%</span>';
		div.style.position = "absolute";
		div.style.left = "0px";
		div.style.top = "0px";
		div.style.width = '100%';
		div.style.height = '${progressBarHeight}px';
		div.style.backgroundColor = 'silver';
		body.appendChild(div);

		progressBar = div;
	}

	function progressGeneration(percent:Float) {
		progressBar.style.width = '$percent%';
		progressBar.style.backgroundColor = 'navy';
	}

	function progressRecording(percent:Float) {
		progressBar.style.width = '$percent%';
		progressBar.style.backgroundColor = 'red';
	}

	// ____________________________________ properties ____________________________________

	public function start() {
		if (pulse == null) {
			console.warn('no pulse detected, hook intro the animation');
		}
		startExport();
	}

	public function stop() {
		stopExport();
	}

	public function debug(?isDebug:Bool = true) {
		this._isDebug = isDebug;
	}

	/**
	 * on completion of the animation call a function with param(s)
	 *
	 * @param  func         	function to call when animition is complete
	 * @param  arr<Dynamic> 	params send to function
	 * @return              Go
	 */
	public function onComplete(func:Dynamic, ?arr:Array<Dynamic>) {
		_onComplete = func;
		_onCompleteParams = arr;
	}

	public function onRecordComplete(func:Dynamic, ?arr:Array<Dynamic>) {
		_onRecordComplete = func;
		_onRecordCompleteParams = arr;
	}

	public function onExportComplete(func:Dynamic, ?arr:Array<Dynamic>) {
		_onExportComplete = func;
		_onExportCompleteParams = arr;
	}

	public function menu(isVisible:Bool = false) {
		this._isMenu = isVisible;
		if (!_isMenu) {
			panel1.hide();
		}
	}

	/**
	 * Create a delay for your recording in frames
	 * @param frames  (most likely 60fps * x.seconds)
	 */
	public function delay(frames:Int) {
		this._delay = frames;
	}

	/**
	 * Create a delay for your recording in seconds,
	 * will be converted to frames
	 * @param sec 	 seconds
	 */
	public function delayInSeconds(sec:Float) {
		this._delay = Math.round(sec * fps);
		panel1.setValue('delay in seconds', sec);
	}

	/**
	 * Record the animation for x number of frames ()
	 * @param frames  (most likely 60fps * x.seconds)
	 */
	public function record(frames:Int) {
		this._record = frames;
	}

	/**
	 * Record the animation for x seconds
	 * will be converted to frames
	 * @param sec 	 seconds
	 */
	public function recordInSeconds(sec:Float) {
		this._record = Math.round(sec * fps);
		panel1.setValue('record in seconds', sec);
	}

	public function pulse() {
		// trace('pulse, $_delayCounter');
		if (isExportActive) {
			// trace('$isExportActive');
			if (_delayCounter < _delay) {
				// trace('>= ${_delay} (delay)');
				if (_isDebug)
					trace('delay: ${_delayCounter} >= ${_delay}');
			}

			if (_delayCounter >= _delay) {
				if (_recordCounter < _record) {
					// trace('< ${_record} (recording)');
					if (_isDebug)
						trace('recording: ${_recordCounter} <  ${_record}');
					imageStringArray.push(_ctx.canvas.toDataURL('image/png').split('base64,')[1]);
					progressRecording((_recordCounter / _record) * 100);
					_recordCounter++;
				} else {
					stopExport();
				}
			}
		}

		_delayCounter++;
	}

	// ____________________________________ inject script into page ____________________________________

	public function embedScripts(?callback:Dynamic, ?callbackArray:String->Void) {
		Embed.script('jszip', 'https://cdnjs.cloudflare.com/ajax/libs/jszip/3.2.0/jszip.min.js', onLoadComplete, ['jszip', callback, callbackArray]);
		Embed.script('jsfilesaver', 'https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js', onLoadComplete,
			['jsfilesaver', callback, callbackArray]);
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
			Reflect.callMethod(callback, callback, ['JsZip and jsFilesaver are ready']);
		}
	}

	// ____________________________________ getter/setter ____________________________________

	function get__isDebug():Bool {
		return _isDebug;
	}

	function set__isDebug(value:Bool):Bool {
		return _isDebug = value;
	}

	function get__ctx():js.html.CanvasRenderingContext2D {
		return _ctx;
	}

	function set__ctx(value:js.html.CanvasRenderingContext2D):js.html.CanvasRenderingContext2D {
		return _ctx = value;
	}

	function get__delay():Int {
		return _delay;
	}

	function set__delay(value:Int):Int {
		return _delay = value;
	}

	function get__record():Int {
		return _record;
	}

	function set__record(value:Int):Int {
		return _record = value;
	}

	function get_description():String {
		return description;
	}

	function set_description(value:String):String {
		return description = value;
	}

	function get__isMenu():Bool {
		return _isMenu;
	}

	function set__isMenu(value:Bool):Bool {
		return _isMenu = value;
	} // ____________________________________ toString ____________________________________

	function toString() {
		return 'ZipExport';
	}
}
