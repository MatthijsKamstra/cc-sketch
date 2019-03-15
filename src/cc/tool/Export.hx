package cc.tool;

import js.html.CanvasRenderingContext2D;
import js.Browser.*;
import js.Browser.window;
import cc.util.MathUtil;

using StringTools;

/**
 * connect to the export server with this socket
 *
 * @example
 * 		import cc.tool.Export;
 *
 * 		export = new Export(ctx);			//
 * 		export.time(15, 2); 				// minimum 3 maximum 60 (instagram settings)
 * 		export.name('${toString()}');		// name of the file used for export (default: `frame`)
 * 		export.folder('_test');				// in `export` folder, will be a new folder with this name (default: `sequence`)
 * 		export.debug(true); 				// activate logs
 * 		export.clear(true);					// clear folder before creating new export
 */
class Export {
	public static var SEND:String = "send";
	public static var MESSAGE:String = "message";
	public static var IMAGE:String = "image";
	public static var SEQUENCE:String = "sequence";
	public static var COMBINE:String = "combine";
	public static var MARKDOWN:String = "md";
	public static var CHECKIN:String = "checkin";
	public static var SERVER_CHECKIN:String = "server-checkin";
	public static var RENDER_CLEAR:String = "render-clear";
	public static var RENDER_FRAME:String = "render-frame";
	public static var RENDER_DONE:String = "render-done";
	public static var TEST:String = "test";

	var _ctx:CanvasRenderingContext2D;
	var _canvas:js.html.CanvasElement;
	var _port:String;
	var _host:String;
	var _socket:Dynamic;
	//
	var _isEmbedded:Bool = false;
	var _isExportServerReady:Bool = false;
	var _isSocketReady:Bool = false;
	var _isTimer:Bool = false;
	var _isDebug:Bool = false;
	var _isClear:Bool = false;
	var _isStart:Bool = false; // is `start()` set... try again when everything is done
	//
	var _duration:Float = 3; // in seconds
	var _delay:Float = 0; // in seconds
	var _currentDuration:Float = 0;
	var _currentDelay:Float = 0;
	// output
	var _name:String = 'frame'; // default file name
	var _folder:String = 'sequence'; // default folder name in the export folder
	var _frameCounter = 0;
	var _currentFrame = 0;
	var _durationFrames = 0;
	var _isRecording:Bool = false;
	var FPS:Int = 60;
	var startTime:Float;

	// <!-- socket.io -->
	// <script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.2.0/socket.io.js" crossorigin="anonymous"></script>

	/**
	 * Make connection with the export node.js server
	 * @param ctx	canvas that needs to be rendered
	 * @param port	server port
	 */
	public function new(ctx:CanvasRenderingContext2D, ?host:String = 'http://localhost', ?port:String = '5000') {
		this._ctx = ctx;
		this._canvas = ctx.canvas;
		this._host = host;
		this._port = port;
		if (checkScript()) {
			// trace('${toString()} start socket');
			initSocket();
		} else {
			embedSocketScript(onScriptIsEmbeddedHandler);
		}
	}

	// ____________________________________ export settings ____________________________________

	/**
	 * [Description]
	 */
	public function start() {
		this._isStart = true;
		if (_isExportServerReady) {
			trace('${toString()} possible start recording');
			reset();
			if (_isTimer) {
				startTime = haxe.Timer.stamp();
				console.log('${toString()} START time base recording (delay: ${_delay}second, frames: ${_durationFrames})');
				haxe.Timer.delay(function() {
					trace('delay time ${haxe.Timer.stamp() - startTime}');
					this._isRecording = true;
					renderSequence();
				}, Math.round(_delay * 1000));
			} else {
				trace('${toString()} WIP normal recording');
			}
		} else {
			if (_isSocketReady) {
				console.warn('Its possible that the export server is not working, check it!');
			} else {
				trace('${toString()} Socket not even ready [comment out]');
			}
		}
	}

	/**
	 * stop recording
	 */
	public function stop() {
		this._isStart = false;
		this._isRecording = false;
	}

	/**
	 * reset everything
	 */
	public function reset() {
		trace('${toString()} reset : make sure everything starts from the beginning');
		this._currentDuration = 0;
		this._currentDelay = 0;
		this._frameCounter = 0;
		this._currentFrame = 0;
		if (_isClear) {
			deleteFolder();
		}
	}

	/**
	 * timed recording instead of start and stop recording
	 *
	 * minimum 3 maximum 60 (instagram settings)
	 *
	 * @param  duration 	(in seconds) minimum 3 sec, maximum 60 sec (Instagram settings) (default: `3`)
	 * @param  delay 		(in seconds) wait before the recording starts (default: `0`)
	 */
	public function time(duration:Float, ?delay:Float = 0) {
		trace('${toString()} Set time: duration:$duration seconds, delay: $delay seconds');
		this._isTimer = true;
		this._duration = MathUtil.clamp(duration, 3.0, 60.0);
		this._durationFrames = Math.round(this._duration * FPS);
		this._delay = delay;
	}

	/**
		* ame of the file used for export (default: `frame`)

		* @param name (default is 'frame') name of the files (example: `cc100` would generate `cc100-0157.png`)
	 */
	public function name(?name:String = 'frame') {
		this._name = name;
	}

	/**
	 * `export` folder, will be a new folder with this name (default: `sequence`)
	 *
	 * @param folder
	 */
	public function folder(?folder:String = 'sequence') {
		this._folder = folder;
	}

	/**
	 * ctivate logs
	 * @param isDebug (default is `false`)
	 */
	public function debug(?isDebug:Bool = false) {
		this._isDebug = isDebug;
	}

	/**
	 * clear folder before creating new export
	 * @param isClear
	 */
	public function clear(?isClear:Bool = true) {
		this._isClear = isClear;
	}

	// ____________________________________ RENDERS ____________________________________

	function renderSequence(?timestamp:Float) {
		var dataString = _canvas.toDataURL(); // default png
		var id = Std.string(Date.now().getTime());
		var data:AST.EXPORT_IMAGE = {
			_id: id,
			file: dataString,
			name: '${_name}-${Std.string(_frameCounter).lpad('0', 4)}',
			folder: '${_folder}',
		}
		if (_isDebug)
			trace('${toString()} renderSequence : ${data._id}');

		_socket.emit(SEQUENCE, data);

		// per 60 frames a mention in the browser
		if (_frameCounter % 60 == 1) {
			trace('current frame render: $_frameCounter/${_durationFrames}');
		}

		if (_frameCounter >= _durationFrames) {
			_isRecording = false;
			trace('${toString()} STOP recording base on frames');
			trace(settings());

			convertRecording();
			_frameCounter--;
		}
		if (_isRecording) {
			window.requestAnimationFrame(renderSequence);
		}
		_frameCounter++;
	}

	// ____________________________________ convert to video ____________________________________

	function convertRecording() {
		var data:AST.EXPORT_CONVERT_VIDEO = {
			name: '${_name}',
			clear: _isClear,
			folder: '${_folder}',
			description: 'export this file '
		};
		_socket.emit(COMBINE, data);
	}

	function deleteFolder() {
		var data:AST.EXPORT_CONVERT_VIDEO = {
			name: '${_name}',
			clear: _isClear,
			folder: '${_folder}',
		};
		_socket.emit(RENDER_CLEAR, data);
	}

	// ____________________________________ init socket (script is embedded) ____________________________________

	function initSocket() {
		trace('${toString()} Init Socket');
		// socket = untyped io();
		_socket = untyped __js__('io.connect({0},{upgradeTimeout: 30000});', '${_host}:${_port}');
		// check possible ways to make sure the server is acitve
		_socket.on('connect_error', function(err) {
			// handle server error here
			console.group('Connection error export server');
			console.warn('${toString()} Error connecting to server "${err}", closing connection');
			console.info('this probably means that cc-export project isn\'t running');
			console.groupEnd();
			_socket.close();
			_isRecording = false;
			_isExportServerReady = false;
		});
		_socket.on("connect", function(err) {
			if (err == 'undefined') {
				trace('${toString()} connect: $err');
			} else {
				trace('${toString()} connect');
			}

			trace('_currentFrame : $_currentFrame');

			if (err == null) {
				_isSocketReady = true;
			}
		});
		_socket.on("disconnect", function(err) {
			trace('${toString()} disconnect: $err');
			_currentFrame = _frameCounter;
			trace('_currentFrame : $_currentFrame');
		});
		_socket.on("connect_failed", function(err) {
			trace('${toString()} connect_failed: $err');
		});
		_socket.on("error", function(err) {
			trace('${toString()} error: $err');
		});
		// messages from the server back
		// _socket.emit('message', 'checkin');
		_socket.on('message', function(data) {
			if (data.message != null) {
				trace('${toString()} message: ' + data.message);
			} else {
				trace('${toString()} There is a problem: ' + data);
			}
		});
		_socket.emit(CHECKIN);
		_socket.on(SERVER_CHECKIN, function(data) {
			if (data.checkin != null && data.checkin == true) {
				_isExportServerReady = true;
				trace('${toString()} data:  + $data, & _isExportServerReady: $_isExportServerReady');
				if (_isStart) {
					// possible that the code was exicuted before the checking was completed, lets try that again
					start();
				}
			} else {
				trace('${toString()} There is a problem: ' + data);
			}
		});
		_socket.on(RENDER_DONE, function(data) {
			trace(data);
		});
	}

	// ____________________________________ check if socketio is embedded in html ____________________________________

	function onScriptIsEmbeddedHandler(a) {
		trace('${toString()} onScriptIsEmbeddedHandler: ${a}');
		checkScript(); // check again ???
		initSocket(); // init
	}

	// ____________________________________ check socket.io script ____________________________________

	function checkScript():Bool {
		var arr = document.getElementsByTagName('script');
		for (i in 0...arr.length) {
			var _script:js.html.ScriptElement = cast arr[i];
			// trace(_script.src);
			if (_script.src.indexOf('socket.io.js') != -1) {
				trace('${toString()} Current page has socket.io script!');
				_isEmbedded = true; // embedding is done
			}
		}
		return _isEmbedded;
	}

	// ____________________________________ inject script into page ____________________________________

	public static function embedScript(?callback:Dynamic, ?callbackArray:Array<Dynamic>) {}

	function embedSocketScript(?callback:Dynamic, ?callbackArray:Array<Dynamic>) {
		trace('${toString()} embedSocketScript');
		var el:js.html.ScriptElement = document.createScriptElement();
		el.id = 'embedSocketIO';
		el.src = 'https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.2.0/socket.io.js';
		el.crossOrigin = 'anonymous';
		el.onload = function() {
			_isEmbedded = true; // embedding is done
			if (callback != null) {
				if (callbackArray == null) {
					Reflect.callMethod(callback, callback, ['socketio']);
				} else {
					Reflect.callMethod(callback, callback, callbackArray);
				}
			}
		}
		document.body.appendChild(el);
	}

	// ____________________________________ getter/setter ____________________________________
	@:isVar public var count(get, null):Int;

	function get_count():Int {
		count = _frameCounter;
		return count;
	}

	@:isVar public var delay(get, null):Float;

	function get_delay():Float {
		return _delay;
	}

	@:isVar public var frames(get, null):Int;

	function get_frames():Int {
		return _durationFrames;
	}

	@:isVar public var duration(get, null):Float;

	function get_duration():Float {
		return _duration;
	}

	// ____________________________________ static  export image ____________________________________

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

	public static function onBase64Handler(ctx:CanvasRenderingContext2D, ?isJpg:Bool = false) {
		var base64 = ctx.canvas.toDataURL((isJpg) ? 'image/jpeg' : '', 1);
		// var base64 = ctx.toDataURL(); // default png
		clipboard(base64);
	}

	// Start file download.
	// ExportUtil.downloadTextFile("This is the content of my file :)", "hello.txt");
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

	// Returns contents of a canvas as a png based data url, with the specified
	// background color
	/*
		public static function canvasToImage(canvas:js.html.CanvasElement, ?backgroundColor:String) {
			// cache height and width
			var w = canvas.width;
			var h = canvas.height;

			var context = canvas.getContext2d();

			var data;
			var compositeOperation:String;

			if (backgroundColor != null) {
				// get the current ImageData for the canvas.
				data = context.getImageData(0, 0, w, h);

				// store the current globalCompositeOperation
				compositeOperation = context.globalCompositeOperation;

				// set to draw behind current content
				context.globalCompositeOperation = "destination-over";

				// set background color
				context.fillStyle = backgroundColor;

				// draw background / rect on entire canvas
				context.fillRect(0, 0, w, h);
			}

			// get the image data from the canvas
			var imageData = canvas.toDataURL("image/png");

			if (backgroundColor != null) {
				// clear the canvas
				context.clearRect(0, 0, w, h);

				// restore it with original / cached ImageData
				context.putImageData(data, 0, 0);

				// reset the globalCompositeOperation to what it was
				context.globalCompositeOperation = compositeOperation;
			}

			// return the Base64 encoded data url string
			return imageData;
		}
	 */
	// ____________________________________ misc ____________________________________

	function settings():String {
		var str = '';

		str += ('_name: ${_name}\n');
		str += ('_folder: ${_folder}\n');
		str += ('count: ${count}\n');
		str += ('_framecounter: ${_frameCounter}\n');
		str += ('frames: ${frames}\n');
		str += ('delay: ${delay} sec\n');
		str += ('duration: ${duration} sec\n');

		return str;
	}

	function toString():String {
		return '[Export]';
	}
}
