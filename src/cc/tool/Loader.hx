package cc.tool;

import js.html.Image;

class Loader {
	@:isVar public var _id(get, set):String;
	@:isVar public var _loadingArray(get, set):Array<LoaderObj> = [];
	public var completeArray:Array<LoaderObj> = [];
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

	/**
	 * create a file loader
	 *
	 * @example
	 * 		import cc.tool.Loader;
	 * 		var load = Loader.create().add(filename).load();
	 *
	 * @param id  (optional) id of the loader, otherwise an id is created
	 */
	public function new(?id:String) {
		if (id == null) {
			this._id = '${toString()}_${Date.now().getTime()}';
		} else {
			this._id = id;
		}
	}

	/**
	 * create a file loader
	 *
	 * @example
	 * 		import cc.tool.Loader;
	 * 		var load = Loader.create().add(filename).load();
	 *
	 * @param id  (optional) id of the loader, otherwise an id is created
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

	/**
	 * add a file to the loading queue
	 *
	 * @param path 	to the file
	 * @param func	oncomplete function when this file is loaded
	 * @param type	if you need this ...
	 * @return Loader
	 */
	inline public function add(path:String, ?func:LoaderObj->Void, ?type:FileType):Loader {
		var _type = (type == null) ? fileType(path) : type;
		var _obj:LoaderObj = {
			path: path,
			type: _type,
			func: func
		};
		if (_isDebug)
			trace(_obj);
		this._loadingArray.push(_obj);
		return this;
	}

	/**
	 * when all files are loaded call this function
	 *
	 * @example:
	 * 		var load = Loader.create().isDebug(true).add('smoelenboek.csv').onComplete(onCompleteHandler).load();
	 *
	 * 		function onCompleteHandler(completeArray:Array<LoaderObj>) {
	 *			trace('onCompleteHandler: ' + completeArray.length);
	 *		}
	 *
	 * @param func		oncomplete function
	 * @param arr		oncomplete extra parameters
	 * @return Loader
	 */
	inline public function onComplete(func:Array<LoaderObj>->Void, ?arr:Array<Dynamic>):Loader {
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

	// ____________________________________ needs to load everthing ____________________________________

	/**
	 * lets start simple
	 * 		expect : 'foo/bar/file.json'
	 *
	 * @param path
	 * @return FileType
	 */
	function fileType(path:String):FileType {
		var type:FileType = Unknown;
		var ext = path.split('.')[1];

		switch (ext.toLowerCase()) {
			case 'jpg', 'jpeg':
				type = JPG;
			case 'gif':
				type = Gif;
			case 'png':
				type = Png;
			case 'json':
				type = Json;
			case 'xml':
				type = Xml;
			case 'txt':
				type = Txt;
			case 'csv':
				type = Csv;
			case _:
				type = Unknown;
		}

		return type;
	}

	function loadingHandler() {
		if (_loadCounter >= _loadingArray.length) {
			if (_isDebug)
				trace('${toString()} :: Loading queue is done');
			if (_isDebug)
				trace('show completed array: ' + completeArray);
			if (_isDebug)
				trace('length of complete files: ' + completeArray.length);
			if (Reflect.isFunction(_onComplete))
				Reflect.callMethod(_onComplete, _onComplete, [completeArray]);
			return;
		}

		// create the image used
		var _l:LoaderObj = _loadingArray[_loadCounter];

		switch (_l.type) {
			case JPEG, JPG, Png, Gif, Img:
				imageLoader(_l);
			case Json, Txt, Xml, Svg, Csv:
				textLoader(_l);
			case _:
				trace('not sure what this type is?: "${_l.path}"');
		}
	}

	function imageLoader(_l:LoaderObj) {
		var _img = new Image();
		_img.crossOrigin = "Anonymous";
		_img.src = _l.path;
		_img.onload = function() {
			if (_isDebug) {
				trace('image source: ' + _img.src);
				trace('image width: ' + _img.width);
				trace('image height: ' + _img.height);
			}
			if (_isDebug)
				trace('complete array length: ' + completeArray.length);
			_l.image = _img;
			completeArray.push(_l);
			if (_isDebug)
				trace('complete array: ' + completeArray);
			if (_isDebug)
				trace('complete array length: ' + completeArray.length);

			if (Reflect.isFunction(_l.func))
				Reflect.callMethod(_l.func, _l.func, [_l]);
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

	function textLoader(_l:LoaderObj) {
		var url = _l.path;
		var req = new haxe.Http(url);
		// req.setHeader('Content-Type', 'application/json');
		// req.setHeader('auth', '${App.TOKEN}');
		req.onData = function(data:String) {
			try {
				_l.str = data;
				if (_l.type == Json) {
					_l.json = haxe.Json.parse(data);
				} else {
					_l.json = '';
				}
				completeArray.push(_l);

				if (Reflect.isFunction(_l.func))
					Reflect.callMethod(_l.func, _l.func, [_l]);

				if (Reflect.isFunction(_onUpdate))
					Reflect.callMethod(_onUpdate, _onUpdate, ['_img']);
				_loadCounter++;

				loadingHandler();
			} catch (e:Dynamic) {
				if (_isDebug)
					trace(e);

				_loadCounter++;
				loadingHandler();
			}
		}
		req.onError = function(error:String) {
			if (_isDebug)
				trace('error: $error');
			_loadCounter++;
			loadingHandler();
		}
		req.onStatus = function(status:Int) {
			if (_isDebug)
				trace('status: $status');
		}
		req.request(true); // false=GET, true=POST
	}

	// ____________________________________ getter/setter ____________________________________

	function get__id():String {
		return _id;
	}

	function set__id(value:String):String {
		return _id = value;
	}

	function get__loadingArray():Array<LoaderObj> {
		return _loadingArray;
	}

	function set__loadingArray(value:Array<LoaderObj>):Array<LoaderObj> {
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

enum FileType {
	Unknown;
	Img;
	IMG;
	Txt;
	TXT;
	Json;
	JSON;
	Gif;
	GIF;
	Png;
	PNG;
	JPEG;
	JPG;
	Xml;
	XML;
	Svg;
	SVG;
	Csv;
	CSV;
}

typedef LoaderObj = {
	var path:String;
	var type:FileType;
	@:optional var _id:Int;
	@:optional var image:js.html.Image;
	@:optional var str:String;
	@:optional var json:Dynamic;
	@:optional var func:Dynamic;
};
