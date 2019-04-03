package cc.tool.export;

import js.Browser.*;
import cc.tool.export.ExportNames.*;

using StringTools;

class ExportNodeServer extends ExportWrapperBase implements IExport {
	var _port:String;
	var _host:String;
	var _socket:Dynamic;
	//
	var _isExportServerReady:Bool = false;
	var _isSocketReady:Bool = false;
	var _isTimer:Bool = false;
	var _isClear:Bool = false;
	var _isRecording:Bool = false;
	//
	// var _frameCounter = 0;
	// var _currentFrame = 0;
	// var _durationFrames = 0;
	var _exportCounter = 0;
	var _exportArray:Array<String>;
	// default export settings
	var _name:String = 'frame'; // default file name
	var _folder:String = 'sequence'; // default folder name in the export folder

	public function new() {
		super();
		// might not be bullit proof!!!
		embedScripts(onEmbedComplete);
	}

	// ____________________________________ public functions ____________________________________

	public function export(obj:ExportWrapper.ExportWrapperObj):Void {
		if (_isDebug)
			trace('${toString()} - export');
		_exportArray = obj.imageStringArray;
		_exportCounter = 0;
		deleteFolder(); // first delete then, via socket start export
		// startExport();
	}

	// ____________________________________ private functions ____________________________________

	function startExport() {
		if (_isDebug)
			trace('startExport: ${_exportCounter} / ${_exportArray.length}');

		if (Reflect.isFunction(_onProgressHandler)) {
			Reflect.callMethod(_onProgressHandler, _onProgressHandler, [(_exportCounter / _exportArray.length) * 100]);
		}
		if (_exportCounter >= _exportArray.length) {
			_isRecording = false;
			if (Reflect.isFunction(_onExportComplete)) {
				Reflect.callMethod(_onExportComplete, _onExportComplete, []);
			}
			if (_isDebug)
				trace('${toString()} STOP recording base on total frames');
			convertExport();
			return;
		}
		var id = Std.string(Date.now().getTime());
		var data:AST.EXPORT_IMAGE = {
			_id: id,
			file: _exportArray[_exportCounter],
			name: '${_name}-${Std.string(_exportCounter).lpad('0', 4)}',
			folder: '${_folder}',
		}

		if (_isDebug)
			trace('${toString()} renderSequence : ${data._id}');

		_socket.emit(SEQUENCE, data);

		// per 60 frames a mention in the browser
		if (_exportCounter % 60 == 1) {
			if (_isDebug)
				trace('current frame render: $_exportCounter/${_exportArray.length}');
		}
	}

	// ____________________________________ convert to video ____________________________________

	function convertExport() {
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
		if (_isDebug)
			trace('${toString()} Init Socket');
		_socket = untyped io();
		// _socket = untyped __js__('io.connect({0},{upgradeTimeout: 30000});', '${_host}:${_port}');
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
			if (err == null) {
				_isSocketReady = true;
			}
		});
		_socket.on("disconnect", function(err) {
			trace('${toString()} disconnect: $err');
			// _currentFrame = _frameCounter;
			// trace('_currentFrame : $_currentFrame');
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
			} else {
				trace('${toString()} There is a problem: ' + data);
			}
		});
		_socket.on(RENDER_DONE, function(data) {
			trace(data);
		});
		_socket.on(RENDER_CLEAR_DONE, function(data) {
			if (_isDebug)
				trace(data.message);
			startExport();
		});
		_socket.on(SEQUENCE_NEXT, function(data) {
			if (_isDebug)
				trace('SEQUENCE_NEXT: ' + data.message);
			_exportCounter++;
			startExport();
		});
	}

	// ____________________________________ inject script into page ____________________________________

	function onEmbedComplete(?value:String) {
		if (_isDebug)
			console.log('${toString()} ${value}');
		initSocket();
	}

	/**
	 * embedScripts(onEmbedComplete);
	 *
	 * @param callback
	 * @param callbackArray
	 */
	public function embedScripts(?callback:Dynamic, ?callbackArray:String->Void) {
		Embed.script('embedSocketIO', 'https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.2.0/socket.io.js', onEmbedComplete,
			['socket.io is embedded and loaded']);
	}

	// ____________________________________ toString() ____________________________________

	override public function toString():String {
		return '[Export via Node]';
	}
}
