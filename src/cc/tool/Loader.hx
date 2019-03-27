package cc.tool;

import js.html.Image;

class Loader {
	@:isVar public var _id(get, set):String;
	@:isVar public var _loadingArray(get, set):Array<String> = [];
	public var completeArray:Array<js.html.Image> = [];
	@:isVar public var _isDebug(get, set):Bool = false;

	var _onComplete:Dynamic;
	var _onCompleteParams:Array<Dynamic>;
	var _onUpdate:Dynamic;
	var _onUpdateParams:Array<Dynamic>;
	var _onProgress:Dynamic;
	var _onProgressParams:Array<Dynamic>;
	var _onError:Dynamic;
	var _onErrorParams:Array<Dynamic>;
	var _loadCounter = 0;

	public function new(?id:String) {
		if (id == null) {
			this._id = '${toString()}_${Date.now().getTime()}';
		} else {
			this._id = id;
		}
	}

	/**
	 * import cc.tool.Loader;
	 *
	 * var load = Loader.create ().draw();
	 *
	 * @return Loader
	 */
	static inline public function create(?id:String):Loader {
		var loader = new Loader(id);
		return loader;
	}

	// ____________________________________ properties ____________________________________

	inline public function isDebug(?isDebug:Bool = true):Loader {
		this._isDebug = isDebug;
		return this;
	}

	inline public function add(path:String):Loader {
		this._loadingArray.push(path);
		return this;
	}

	inline public function onComplete(func:Array<js.html.Image>->Void, ?arr:Array<Dynamic>):Loader {
		this._onComplete = func;
		this._onCompleteParams = arr;
		return this;
	}

	inline public function onUpdate(func:Dynamic, ?arr:Array<Dynamic>):Loader {
		this._onUpdate = func;
		this._onUpdateParams = arr;
		return this;
	}

	inline public function onProgress(func:Dynamic, ?arr:Array<Dynamic>):Loader {
		this._onProgress = func;
		this._onProgressParams = arr;
		return this;
	}

	inline public function onError(func:Dynamic, ?arr:Array<Dynamic>):Loader {
		this._onError = func;
		this._onErrorParams = arr;
		return this;
	}

	inline public function load():Loader {
		if (_isDebug)
			trace('start loading');
		loadingHandler();
		return this;
	}

	function loadingHandler() {
		if (_loadCounter >= _loadingArray.length) {
			if (_isDebug)
				trace('${toString()} :: Loading queue is done');
			if (_isDebug)
				trace(completeArray);
			if (_isDebug)
				trace(completeArray.length);
			if (Reflect.isFunction(_onComplete))
				Reflect.callMethod(_onComplete, _onComplete, [completeArray]);
			return;
		}

		// create the image used
		var _img = new Image();

		_img.crossOrigin = "Anonymous";
		_img.src = _loadingArray[_loadCounter];
		_img.onload = function() {
			if (_isDebug)
				trace('w: ' + _img.width);
			if (_isDebug)
				trace('h: ' + _img.height);
			if (_isDebug)
				trace(completeArray.length);
			completeArray.push(_img);
			if (_isDebug)
				trace(completeArray);
			if (_isDebug)
				trace(completeArray.length);

			if (Reflect.isFunction(_onUpdate))
				Reflect.callMethod(_onUpdate, _onUpdate, [_img]);
			_loadCounter++;
			loadingHandler();
		}

		_img.onerror = function() {
			if (Reflect.isFunction(_onError))
				Reflect.callMethod(_onError, _onError, [_img]);
			_loadCounter++;
			loadingHandler();
		}

		_img.onprogress = function() {
			if (Reflect.isFunction(_onProgress))
				Reflect.callMethod(_onProgress, _onProgress, [_img]);
		}
	}

	// ____________________________________ getter/setter ____________________________________

	function get__id():String {
		return _id;
	}

	function set__id(value:String):String {
		return _id = value;
	}

	function get__loadingArray():Array<String> {
		return _loadingArray;
	}

	function set__loadingArray(value:Array<String>):Array<String> {
		return _loadingArray = value;
	}

	function get__isDebug():Bool {
		return _isDebug;
	}

	function set__isDebug(value:Bool):Bool {
		return _isDebug = value;
	}

	// ____________________________________ misc ____________________________________

	function toString() {
		return '[Loader]';
	}
}
