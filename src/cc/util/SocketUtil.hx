package cc.util;

import js.html.CanvasRenderingContext2D;
import js.html.*;
import js.Browser.document;
import js.Browser.*;
import js.Browser.window;

// import cc.Global.*;
using StringTools;

class SocketUtil {
	var ctx:CanvasRenderingContext2D;
	var port:String;
	var socket:Dynamic;
	var isEmbedded:Bool = false;

	// <!-- socket.io -->
	// <script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.2.0/socket.io.js" crossorigin="anonymous"></script>
	/**
	 * [Description]
	 * @param ctx
	 * @param port
	 */
	public function new(ctx:CanvasRenderingContext2D, ?port:String = '5000') {
		this.ctx = ctx;
		this.port = port;
		if (checkScript()) {
			// trace('start socket');
			initSocket();
		} else {
			embedScript(onEmbedHandler);
		}
	}

	function onEmbedHandler(a) {
		trace('onEmbedHandler: ${a}');
		checkScript();
		initSocket();
	}

	function initSocket() {
		trace('initSocket');
		// socket = untyped io();
		socket = untyped __js__('io.connect({0});', 'http://localhost:${port}');

		socket.on('connect_error', function(err) {
			// handle server error here
			trace('Error connecting to server "${err}", closing connection');
			socket.close();
		});

		socket.on("connect", function(err) {
			trace('connect: $err');
		});
		socket.on("disconnect", function(err) {
			trace('disconnect: $err');
		});
		socket.on("connect_failed", function(err) {
			trace('connect_failed: $err');
		});
		socket.on("error", function(err) {
			trace('error: $err');
		});
		socket.emit('message', 'checkin');
		socket.on('message', function(data) {
			if (data.message != null) {
				trace("data: " + data);
			} else {
				trace("There is a problem: " + data);
			}
		});
	}

	function checkScript():Bool {
		var arr = document.getElementsByTagName('script');
		for (i in 0...arr.length) {
			var _script:js.html.ScriptElement = cast arr[i];
			// trace(_script.src);
			if (_script.src.indexOf('socket.io.js') != -1) {
				trace('Current page has socket.io script!');
				isEmbedded = true;
			}
		}
		return isEmbedded;
	}

	public static function embedScript(?callback:Dynamic, ?callbackArray:Array<Dynamic>) {
		trace('embedScript');
		var el:js.html.ScriptElement = document.createScriptElement();
		el.id = 'embedSocketIO';
		el.src = 'https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.2.0/socket.io.js';
		el.crossOrigin = 'anonymous';
		el.onload = function() {
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
}
