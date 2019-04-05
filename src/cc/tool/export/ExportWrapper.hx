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

class ExportWrapper //  implements IExportWrapper
{
	var fps:Int = 60;
	var panel1:QuickSettings;
	var isExportActive:Bool = false;
	// counters
	var _delayCounter:Int = 0;
	var _recordCounter:Int = 0;
	// progress bar
	var _progressBar:DivElement;
	var _progressBarHeight = 3;

	@:isVar public var description(get, set):String = '';
	@:isVar public var _delay(get, set):Int = 120; // (60*3) 60fps * 3sec
	@:isVar public var _record(get, set):Int = 600; // (60*10) 60fps * 5sec
	@:isVar public var _ctx(get, set):js.html.CanvasRenderingContext2D;
	@:isVar public var _isMenu(get, set):Bool = true;
	@:isVar public var _isDebug(get, set):Bool;
	@:isVar public var _type(get, set):ExportType = ExportType.NONE;

	var _filename:String;
	// timer
	var _startT:Float;
	var _endT:Float;
	// var imageArray:Array<js.html.ImageData> = [];
	var imageStringArray:Array<String> = [];
	// callback functions
	var _onComplete:Dynamic;
	var _onCompleteParams:Array<Dynamic>;
	var _onRecordComplete:Dynamic;
	var _onRecordCompleteParams:Array<Dynamic>;
	var _onRecordStart:Dynamic;
	var _onRecordStartParams:Array<Dynamic>;
	var _onExportComplete:Dynamic;
	var _onExportCompleteParams:Array<Dynamic>;
	// export types
	var exportZip:ExportZip;
	var exportNode:ExportNodeServer;
	var exportType:IExport;

	/**
	 * [Description]
	 * @param ctx
	 * @param fileName
	 */
	public function new(ctx:CanvasRenderingContext2D, ?fileName:String) {
		createQuickSettings();
		create_ProgressBar();

		if (ctx == null) {
			console.warn('This is not acceptable, I need a context!');
			return;
		}

		this._filename = (fileName == null) ? toString() : fileName;
		this._ctx = ctx;
		out('ExportWrapper ready');
	}

	// ____________________________________ start and stop export ____________________________________

	function startExport() {
		_startT = Date.now().getTime();
		isExportActive = true;
		imageStringArray = [];
		_delayCounter = 0;
		_recordCounter = 0;
		out('${toString()} - start export - 0ms');
		if (_isDebug) {
			trace(toString() + ' - start export - 0ms');
			trace(settings());
		}
	}

	function stopExport() {
		_endT = Date.now().getTime();
		isExportActive = false;
		out(toString() + ' - stop export - ${(_endT - _startT) / 1000}sec');
		if (_isDebug) {
			trace(toString() + ' - stop export - ${(_endT - _startT) / 1000}sec');
			trace(settings());
		}

		if (Reflect.isFunction(_onComplete)) {
			var arr = (_onCompleteParams != null) ? _onCompleteParams : [];
			Reflect.callMethod(_onComplete, _onComplete, arr);
		}
		if (Reflect.isFunction(_onRecordComplete)) {
			var arr = (_onRecordCompleteParams != null) ? _onRecordCompleteParams : [];
			Reflect.callMethod(_onRecordComplete, _onRecordComplete, arr);
		}

		var timeStamp = _endT;

		// zips case I am going to assum it already is loaded... is this not the case,
		// set a boolean to help with that
		trace(exportType.toString());
		exportType.progress(progressGeneration);
		exportType.complete(_onExportComplete);
		exportType.debug(_isDebug);
		exportType.export(settings());
	}

	// ____________________________________ properties ____________________________________

	/**
	 * init project,
	 * use delay in frames
	 * use recording frames
	 */
	public function init() {
		if (pulse == null) {
			console.warn('no pulse detected, hook into the animation');
			return;
		}
		startExport();
	}

	/**
	 * Start recording now
	 * reset _delay
	 */
	public function start() {
		_delay = 0; // start now, so reset everthing
		init();
	}

	/**
	 * Stop recording now
	 */
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
	 */
	public function onComplete(func:Dynamic, ?arr:Array<Dynamic>) {
		_onComplete = func;
		_onCompleteParams = arr;
	}

	/**
	 * start of the recording, might be at once, or after a deplay
	 *
	 * @param  func         	function to call when animition is complete
	 * @param  arr<Dynamic> 	params send to function
	 */
	public function onRecordStart(func:Dynamic, ?arr:Array<Dynamic>) {
		_onRecordStart = func;
		_onRecordStartParams = arr;
	}

	/**
	 * when recording is done, completed
	 *
	 * @param  func         	function to call when animition is complete
	 * @param  arr<Dynamic> 	params send to function
	 */
	public function onRecordComplete(func:Dynamic, ?arr:Array<Dynamic>) {
		_onRecordComplete = func;
		_onRecordCompleteParams = arr;
	}

	/**
	 * when the export is ready
	 * usefull when using zip
	 *
	 * @param  func         	function to call when animition is complete
	 * @param  arr<Dynamic> 	params send to functionr
	 */
	public function onExportComplete(func:Dynamic, ?arr:Array<Dynamic>) {
		_onExportComplete = func;
		_onExportCompleteParams = arr;
	}

	/**
	 * show quick settings menu
	 * @param isVisible
	 */
	public function menu(isVisible:Bool = false) {
		this._isMenu = isVisible;
		if (!_isMenu) {
			panel1.hide();
		}
	}

	public function type(type:ExportType) {
		this._type = type;
		switch (this._type) {
			case ZIP:
				exportType = new ExportZip();
			case NODE:
				exportType = new ExportNodeServer();
			case NONE, TEST:
				exportType = new ExportNone();
			case _:
				exportType = new ExportNone();
		}
	}

	/**
	 * other version of type, lets see which one I will remember
	 * @param type
	 */
	public function exporttype(type:ExportType) {
		this.type(type);
	}

	/**
	 * Create a delay for your recording in frames
	 *
	 * @param frames  (most likely 60fps * x.seconds)
	 */
	public function delay(frames:Int) {
		this._delay = frames;
	}

	/**
	 * Create a delay for your recording in seconds,
	 * will be converted to frames
	 *
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

	/**
	 * get some basic feedback on the settings used with this wrapper
	 */
	public function settings() {
		var obj:ExportWrapperObj = {
			filename: _filename,
			export_type: _type,
			delay: _delay,
			record: _record,
			delay_in_seconds: (_delay / 60),
			record_in_seconds: (_record / 60),
			imageStringArray: imageStringArray,
			timestamp: Date.now().getTime(),
			description: '',
		};
		return obj;
	}

	public function isDebug(?isDebug:Bool = true) {
		this._isDebug = isDebug;
	}

	/**
	 * the pulse should be hooked into the window framerate
	 */
	public function pulse() {
		// console.log('${toString()} pulse -> delayCounter: $_delayCounter, $_delay, $isExportActive');
		if (isExportActive) {
			// trace('$isExportActive');
			if (_delayCounter < _delay) {
				// trace('>= ${_delay} (delay)');
				if (_isDebug)
					console.log('${toString()} delay: ${_delayCounter} < ${_delay}');
			}

			if (_delayCounter == _delay) {
				// should only be called once
				if (_isDebug)
					console.log('${toString()} onRecordStart: ${_delayCounter} == ${_delay}');
				if (Reflect.isFunction(_onRecordStart)) {
					var arr = (_onRecordStartParams != null) ? _onRecordStartParams : [];
					Reflect.callMethod(_onRecordStart, _onRecordStart, arr);
				}
			}
			if (_delayCounter >= _delay) {
				if (_recordCounter < _record) {
					// trace('< ${_record} (recording)');
					if (_isDebug)
						console.log('${toString()} recording: ${_recordCounter} < ${_record}');
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

	// ____________________________________ settings stuff ____________________________________

	function createQuickSettings() {
		panel1 = QuickSettings.create(10, 10, "ExportWrapper settings")
			.addRange('delay in seconds', 0.0, 5.0, 2.0, 0.5, function(e) setDelay(e))
			.addRange('record in seconds', 0.0, 60.0, 2.0, 0.5, function(e) setRecord(e))

			.addButton('recording', function(e) onClickHandler(e))
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
		out('recording in seconds: ' + Std.string(e));
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

	// ____________________________________ html progress ____________________________________

	function create_ProgressBar(?percentage:Int = 10) {
		var body = document.querySelector('body');
		var div:DivElement = document.createDivElement();
		div.setAttribute("id", 'zip-progress');
		div.innerHTML = '<span style="display:none">$percentage%</span>';
		div.style.position = "absolute";
		div.style.left = "0px";
		div.style.top = "0px";
		div.style.width = '100%';
		div.style.height = '${_progressBarHeight}px';
		div.style.backgroundColor = 'silver';
		body.appendChild(div);

		_progressBar = div;
	}

	function progressGeneration(percent:Float) {
		_progressBar.style.width = '$percent%';
		_progressBar.style.backgroundColor = 'navy';
	}

	function progressRecording(percent:Float) {
		_progressBar.style.width = '$percent%';
		_progressBar.style.backgroundColor = 'red';
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
	}

	function get__type():ExportType {
		return _type;
	}

	function set__type(value:ExportType):ExportType {
		return _type = value;
	}

	// ____________________________________ toString ____________________________________

	function toString() {
		return '[ExportWrapper]';
	}
}

enum ExportType {
	ZIP;
	NODE;
	NONE;
	TEST;
}

typedef ExportWrapperObj = {
	// @:optional var _id : Int;
	var filename:String;
	var export_type:ExportType;
	var delay:Int;
	var record:Int;
	var delay_in_seconds:Float;
	var record_in_seconds:Float;
	var imageStringArray:Array<String>;
	var timestamp:Float;
	@:optional var description:String;
};
