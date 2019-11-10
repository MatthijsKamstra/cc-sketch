package cc.lets;

import cc.lets.Easing;
import haxe.Timer;
import cc.lets.easing.Quad;
import cc.lets.easing.IEasing;
import js.Browser.*;

/**
 * version
 * 		1.1.0 - 3D additions (z-dir)
 * 		1.0.9 - Haxe 4 update
 * 		1.0.8 - arc
 * 		1.0.7 - wiggle
 * 		1.0.6 - convert to js only
 */
class Go {
	// private static var _trigger:Timer;
	// private static var _trigger:Int; // requestAnimationFrame
	private static var _requestId:Int; // requestAnimationFrame
	private static var _tweens:Array<Go> = new Array<Go>();

	private var _id:String;
	private var _target:Dynamic;
	private var _duration:Int; // is set in seconds, but is eventually converted to miliseconds
	// private var _easing:Float->Float = Easing.linear;
	private var _easing:IEasing = Quad.easeOut;
	private var _options:Dynamic = cast {};
	private var _props = new Map<String, Range>();
	private var _isFrom:Bool = false;
	private var _isYoyo:Bool = false;
	private var _isWiggle:Bool = false;
	private var _isOrbit:Bool = false;
	private var _isTimeBased:Bool = false; // default is frameBased
	private var _isDelayDone:Bool = false; // default is frameBased
	private var _initTime:Int = 0; // should work with time (miliseconds) and frames (FPS)
	private var _delay:Int = 0;
	private var _seconds:Float = 0;
	private var _arc:Float = 0;
	private var FRAME_RATE:Int = 60; // 60 frames per second (FPS)
	private var DEBUG:Bool = false;
	private var VERSION:String = '1.1.0';

	/**
	 * Animate an object to another state (like position, scale, rotation, alpha)
	 *
	 * @example		cc.lets.Go.to(foobarMc, 1.5);
	 *
	 * @param  target   	object to animate
	 * @param  duration 	in seconds
	 */
	public function new(target:Dynamic, duration:Float) {
		this._id = '[lets.Go]$VERSION.' + Date.now().getTime();
		this._seconds = duration;
		this._target = target;
		this._duration = getDuration(duration);
		// this._options = cast{};
		if (_isTimeBased) {
			this._initTime = getTimer();
		} else {
			this._initTime = this._duration;
		}
		_tweens.push(this);
		if (DEBUG)
			console.log('New Go - _id: "$_id" / _duration: ' + _duration + ' / _initTime: ' + _initTime + ' / _tweens.length: ' + _tweens.length);
		// [mck] extreme little delay to make sure all the values are set
		// init();
		haxe.Timer.delay(init, 1); // 1 milisecond delay

		// [mck] TODO check if there is a tween attached to the same animation?
	}

	/**
	 * Animate an object TO another state (like position, scale, rotation, alpha)
	 *
	 * @example		lets.Go.to(foobarMc, 1.5);
	 *
	 * @param  target   	object to animate
	 * @param  duration 	in seconds
	 * @return          Go
	 */
	static inline public function to(target:Dynamic, duration:Float):Go {
		var Go = new Go(target, duration);
		Go._isFrom = false;
		return Go;
	}

	/**
	 * Animate an object FROM another state (like position, scale, rotation, alpha)
	 *
	 * @example		lets.Go.from(foobarMc, 1.5);
	 *
	 * @param  target   	object to animate
	 * @param  duration 	in seconds
	 * @return          Go
	 */
	static inline public function from(target:Dynamic, duration:Float):Go {
		var Go = new Go(target, duration);
		Go._isFrom = true;
		Go.updateProperties(0); // this can't be done faster
		return Go;
	}

	/**
	 * Use Go to do a delayed call to a function
	 *
	 * @example		lets.Go.timer(1.5).onComplete(onCompleteHandler);
	 *
	 * @param  duration 	in seconds
	 * @return          Go
	 */
	static inline public function timer(duration:Float):Go {
		var Go = new Go({}, duration);
		return Go;
	}

	/**
	 * Use Go.frames to create a time/delay to a functoin
	 *
	 * @example		Go.frames(1).onComplete(onCompleteHandler);
	 *
	 * @param frames 	frames to wait
	 * @return Go
	 */
	static inline public function frames(frames:Int):Go {
		var Go = new Go({}, (frames * 60));
		return Go;
	}

	/**
	 * continues wiggling of an object in random x and y dir
	 *
	 * @example		Go.wiggle(foobarMc, 10, 10, 10);
	 *
	 * @param target   		object to animate
	 * @param x				centerpoint x
	 * @param y				centerpoint y
	 * @param wiggleRoom	offset from x and y
	 * @return Go
	 */
	static inline public function wiggle(target:Dynamic, x:Float, y:Float, ?wiggleRoom:Float = 10):Go {
		var _go = new Go(target, 1 + (Math.random()));
		_go._isWiggle = true;
		var max = wiggleRoom;
		var min = -wiggleRoom;
		_go.prop('x', x + (Math.random() * (max - min)) + min);
		_go.prop('y', y + (Math.random() * (max - min)) + min);
		_go.ease(cc.lets.easing.Sine.easeInOut);
		_go.onComplete(function() {
			Go.wiggle(target, x, y, wiggleRoom);
		});
		return _go;
	}

	/**
	 * continues wiggling of an object in random dir
	 *
	 * @example		Go.wiggleProp(foobarMc.position, 'z', 0, 20);
	 *
	 * @param target   		object contains the data to animate
	 * @param prop			value you want to animate
	 * @param value			starting point value
	 * @param wiggleRoom	offset from starting point, max min
	 * @return Go
	 */
	static inline public function wiggleProp(target:Dynamic, prop:String, value:Float, ?wiggleRoom:Float = 10):Go {
		var _go = new Go(target, 1 + (Math.random()));
		_go._isWiggle = true;
		var max = wiggleRoom;
		var min = -wiggleRoom;
		_go.prop(prop, value + (Math.random() * (max - min)) + min);
		_go.ease(cc.lets.easing.Sine.easeInOut);
		_go.onComplete(function() {
			Go.wiggleProp(target, prop, value, wiggleRoom);
		});
		return _go;
	}

	static inline public function orbit(target:Dynamic, x:Float, y:Float, radius:Int, speed:Float):Go {
		var _go = new Go(target, 1 + (Math.random()));
		_go._isOrbit = true;

		_go.prop('x', x);
		_go.prop('y', y);
		_go.prop('cx', x);
		_go.prop('cy', y);
		_go.prop('radius', radius);
		_go.prop('speed', speed);
		_go.prop('angle', speed);

		Reflect.setField(target, 'cx', x);
		Reflect.setField(target, 'cy', y);
		Reflect.setField(target, 'angle', 0);
		Reflect.setField(target, 'speed', speed);
		Reflect.setField(target, 'radius', radius);

		// _go.prop('x', x + (Math.random() * (max - min)) + min);
		// _go.prop('y', y + (Math.random() * (max - min)) + min);
		// _go.ease(cc.lets.easing.Sine.easeInOut);
		// _go.onComplete(function() {
		// 	Go.wiggle(target, x, y, wiggleRoom);
		// });
		return _go;
	}

	/**
	 * default the animation is framebased (`requestAnimationFrame`) and will stop animating when focus is gone
	 * but perhaps time is important
	 *
	 * @example		Go.from(foobarMc, 1.5).isTimeBased();
	 *
	 * @param  isTimeBased  (optional)
	 * @return Go
	 */
	inline public function isTimeBased(?isTimeBased:Bool = true):Go {
		trace('Fixme: this doesn\t work right now');
		_isTimeBased = isTimeBased;
		_duration = Std.int(_duration / FRAME_RATE);
		return this;
	}

	// ____________________________________ properties ____________________________________

	/**
	 * [Description]
	 * @param value
	 * @return Go
	 */
	inline public function width(value:Float):Go {
		prop('width', value);
		return this;
	}

	/**
	 * [Description]
	 * @param value
	 * @return Go
	 */
	inline public function height(value:Float):Go {
		prop('height', value);
		return this;
	}

	/**
	 * change the x value of an object
	 *
	 * @example		Go.to(foobarMc, 1.5).x(10);
	 *
	 * @param  value 	x-position
	 * @return       Go
	 */
	inline public function x(value:Float):Go {
		prop('x', value);
		return this;
	}

	/**
	 * change the y value of an object
	 *
	 * @example		Go.to(foobarMc, 1.5).y(10);
	 *
	 * @param  value 	y-position
	 * @return       Go
	 */
	inline public function y(value:Float):Go {
		prop('y', value);
		return this;
	}

	/**
	 * change the z value of an object
	 * 3D z added
	 *
	 * @example		Go.to(foobarMc, 1.5).z(10);
	 *
	 * @param value
	 * @return Go
	 */
	inline public function z(value:Float):Go {
		prop('z', value);
		return this;
	}

	/**
	 * change the y value of an object
	 *
	 * @example		Go.to(foobarMc, 1.5).pos(10,20);
	 *
	 * @param  x 	x-position
	 * @param  y 	y-position
	 * @param  z 	(optinal) z-position
	 * @return       Go
	 */
	inline public function pos(x:Float, y:Float, ?z:Float):Go {
		prop('x', x);
		prop('y', y);
		if (z != null)
			prop('z', z);
		return this;
	}

	/**
	 * change the rotation value of an object
	 *
	  	 * @example		Go.to(foobarMc, 1.5).rotation(10);
	 *
	 * @param  degree 	rotation in degrees (360)
	 * @return       Go
	 */
	inline public function rotation(degree:Float):Go {
		prop('rotation', degree);
		return this;
	}

	inline public function degree(degree:Float):Go {
		prop('rotation', degree);
		return this;
	}

	inline public function radians(degree:Float):Go {
		prop('rotation', degree * Math.PI / 180);
		return this;
	}

	// [mck] do I need a conversion between degree and radians?

	/**
	 * change the alpha value of an object
	 *
	 * @example		Go.to(foobarMc, 1.5).alpha(.1);
	 *
	 * @param  value 	transparanty value (maximum value 1)
	 * @return       Go
	 */
	inline public function alpha(value:Float):Go {
		prop('alpha', value);
		return this;
	}

	/**
	 * change the scale of an object
	 *
	 * @example		Go.to(foobarMc, 1.5).scale(2);
	 *
	 * @param  value 	scale (1 is 100% (original scale), 0.5 is 50%, 2 is 200%)
	 * @return       Go
	 */
	inline public function scale(value:Float):Go {
		prop('scaleX', value); // might be values needed from previous Go version
		prop('scaleY', value); // might be values needed from previous Go version
		prop('scale', value);
		return this;
	}

	/**
	 * yoyo to the original values of an object
	 * its back and forth, only once.. use oncomplete to continuesly to do this
	 *
	 * @example		Go.to(foobarMc, 1.5).yoyo();
	 *
	 * @return       Go
	 */
	inline public function yoyo():Go {
		_isYoyo = true;
		return this;
	}

	inline public function arc(?dir:Int):Go {
		this._arc = 0;
		return this;
	}

	/**
	 * delay the animation in seconds
	 *
	 * @example		Go.to(foobarMc, 1.5).delay(1.5);
	 *
	 * @param duration 	delay in seconds
	 * @return       Go
	 */
	inline public function delay(duration:Float):Go {
		_delay = getDuration(duration);
		return this;
	}

	/**
	 * change the property of an object
	 *
	 * @example		Go.to(foobarMc, 1.5).prop('counter',10);
	 *
	 * @param  key   	description of the property as string
	 * @param  value 	change to this value
	 * @return       Go
	 */
	inline public function prop(key:String, value:Float):Go {
		// [mck] TODO set zero value if it doesn't exist
		var objValue = 0;
		if (Reflect.hasField(_target, key)) {
			objValue = Reflect.getProperty(_target, key);
		}

		var _range = {key: key, from: (_isFrom) ? value : objValue, to: (!_isFrom) ? value : objValue};
		_props.set(key, _range);

		// [mck] make sure the `_isFrom` is set asap
		if (_isFrom)
			updateProperties(0);

		return this;
	}

	/**
	 * on completion of the animation call a function with param(s)
	 *
	 * @param  func         	function to call when animition is complete
	 * @param  arr<Dynamic> 	params send to function
	 * @return              Go
	 */
	inline public function onComplete(func:Dynamic, ?arr:Array<Dynamic>):Go {
		_options.onComplete = func;
		_options.onCompleteParams = arr;
		return this;
	}

	/**
	 * on update of the animation call a function with param(s)
	 *
	 * @param  func         	function to call when animition is updated
	 * @param  arr<Dynamic> 	params send to function
	 * @return              Go
	 */
	inline public function onAnimationStart(func:haxe.Constraints.Function, ?arr:Array<Dynamic>):Go {
		_options.onAnimationStart = func;
		_options.onAnimationStartParams = arr;
		return this;
	}

	/**
	 * on update of the animation call a function with param(s)
	 *
	 * ```
	 * Go.to(rect, 1.5).x(600).onUpdate(onUpdateHandler, [rect]).onComplete(onAnimateHandler, []);
	 * ```
	 *
	 * @param  func         	function to call when animation is updated
	 * @param  arr<Dynamic> 	params send to function
	 * @return              Go
	 */
	inline public function onUpdate(func:Dynamic, ?arr:Array<Dynamic>):Go {
		_options.onUpdate = func;
		_options.onUpdateParams = arr;
		return this;
	}

	/**
	 * change the default (Easing.linear) easing
	 *
	 * @example		Go.from(foobarMc, 1.5).x(500).easing(Easing.quad);
	 *
	 * @param  easing->Float 		check Easing class
	 * @return		Go
	 */
	// inline public function ease(easing:Float->Float):Go {
	inline public function ease(easing:IEasing):Go {
		this._easing = easing;
		return this;
	}

	// ____________________________________ public ____________________________________

	/**
	 * stop a Go tween while its animating
	 *
	 * @example 	var tween : Go = lets.Go.to(foobarMc, 20).x(100);
	 *           	// oh dumb dumb, I want to stop that long animation because x-reason
	 *           	tween.stop();
	 */
	public function stop():Void {
		destroy();
	}

	// ____________________________________ private ____________________________________
	private function init():Void {
		if (_isTimeBased) {
			// [mck] TODO clean this up!!!!
			trace('TODO: build timebased animation');
			// var framerate:Int = Math.round(FRAME_RATE / 2); //30;
			// _trigger = (_trigger == null) ? new Timer(Std.int(1000 / framerate)) : _trigger;
			// _trigger.run = onEnterFrameHandler;
		} else {
			if (_requestId == null) {
				// console.info('start frame animation');
				_requestId = window.requestAnimationFrame(onEnterFrameHandler);
				// trace(_requestId);
			}
		}
	}

	private function onEnterFrameHandler(?time:Float):Void {
		// if (_initTime == 0) return;
		if (_tweens.length <= 0) {
			// [mck] stop timer, we are done!
			if (_isTimeBased) {
				// _trigger.stop();
				// _trigger.run = null;
			} else {
				// trace('kill $_requestId');
				window.cancelAnimationFrame(_requestId);
				return;
			}
		} else
			for (i in 0..._tweens.length) {
				// [mck] FIXME :: don't know exactly why I need to check if _tweens[i] != null, but I do.
				if (_tweens[i] != null)
					_tweens[i].update();
			}

		_requestId = window.requestAnimationFrame(onEnterFrameHandler);
	}

	private function update():Void {
		// [mck] check for delay, simply count down the delay before we animate
		// [mck] TODO doesn't work with time
		if (_delay > 0 && _isTimeBased)
			trace('FIXME this doesn\'t work yet');
		if (_delay > 0) {
			_delay--;
			return;
		}
		if (!_isDelayDone) {
			if (DEBUG)
				trace('should trigger only once: ${_id}');
			if (Reflect.isFunction(_options.onAnimationStart)) {
				var func = _options.onAnimationStart;
				var arr:Array<Dynamic> = (_options.onAnimationStartParams != null) ? _options.onAnimationStartParams : [];
				Reflect.callMethod(func, func, [arr]);
			}
		}
		_isDelayDone = true;

		// if (_delay > 0) {
		// 	_delay--;
		// 	// var waitTime = (getTimer() - _initTime);
		// 	// if (waitTime >= _delay) {
		// 	// 	_delay = 0;
		// 	// 	if(_isTimeBased){
		// 	// 		_initTime = getTimer();
		// 	// 	} else {
		// 	// 		_initTime--;
		// 	// 	}
		// 	return null;
		// // } else {
		// // 	return null;
		// }

		this._initTime--;
		var progressed = (this._duration - this._initTime);
		if (_isTimeBased) {
			progressed = getTimer() - _initTime;
		}
		// trace ('$progressed >= $_duration');
		if (progressed >= this._duration) {
			// [mck] setProperties in the final state
			updateProperties(this._duration);
			complete();
		} else {
			updateProperties(progressed);
		}
	}

	private function updateProperties(time:Float):Void {
		if (Reflect.isFunction(_options.onUpdate)) {
			var func = _options.onUpdate;
			var arr = (_options.onUpdateParams != null) ? _options.onUpdateParams : [];
			Reflect.callMethod(func, func, [arr]);
		}
		// [mck] for some reason this can be null
		if (_props == null)
			return;
		for (n in _props.keys()) {
			var range = _props.get(n);
			if (_isOrbit) {
				// trace('clever stuff $n ($_props) , $range');
				var __cx:Range = _props.get('cx');
				var __cy:Range = _props.get('cy');
				var __angle:Range = _props.get('angle');
				var __speed:Range = _props.get('speed');
				var __rad:Range = _props.get('radius');

				trace('cx: ${__cx.to},  cy: ${__cy.to} , ${__angle.to}, ${__speed.to}, ${__rad.to}');

				// if (n == 'x') {
				// 	var xx = __cx.to + Math.cos(radians(__angle.to)) * __rad.to;
				// 	Reflect.setProperty(_target, n, xx);
				// }
				// if (n == 'y') {
				// 	var yy = __cy.to + Math.sin(radians(__angle.to)) * __rad.to;
				// 	Reflect.setProperty(_target, n, yy);
				// }

				trace('$n == "angle" : ' + (n == 'angle'));

				trace(_target);

				if (n == 'angle') {
					var aa = __angle.to + __speed.to;
					Reflect.setProperty(_target, n, aa);
				}

				// var radius = 50;
				// var speed = 2;
				// untyped sh.angle += speed;
				// // plot the balls x to cos and y to sin
				// sh.x = w / 2 + Math.cos(radians(untyped sh.angle)) * radius;
				// sh.y = h / 2 + Math.sin(radians(untyped sh.angle)) * radius;
			} else {
				// Reflect.setProperty(_target, n, _easing(time / _duration) * (range.to - range.from) + range.from);
				Reflect.setProperty(_target, n, _easing.ease(time, range.from, (range.to - range.from), _duration));
			}
		}
		// else throw( "Property "+propertyName+" not found in target!" );
	}

	private function complete():Void {
		if (DEBUG)
			trace('complete :: "$_id", _duration: $_duration, _seconds: $_seconds, _initTime: '
				+ _initTime
				+ ' / _tweens.length: '
				+ _tweens.length);

		if (_isYoyo) {
			// [mck] reverse the props back to the original state
			for (n in _props.keys()) {
				var range = _props.get(n);
				var _rangeReverse = {key: n, from: range.to, to: range.from};
				_props.set(n, _rangeReverse);
			}
			// [mck] reset the time and ignore this function for now... :)
			if (_isTimeBased) {
				this._initTime = getTimer();
			} else {
				this._initTime = _duration;
			}
			_isYoyo = false;
			return;
		}

		var func = _options.onComplete;
		var arr = (_options.onCompleteParams != null) ? _options.onCompleteParams : [];

		destroy();

		if (Reflect.isFunction(func))
			Reflect.callMethod(func, func, [arr]);
	}

	/**
	 * function to calculate the duration (frames or miliseconds)
	 * @param duration 	given in seconds, recalculated to miliseconds OR frame
	 */
	function getDuration(duration:Float):Int {
		var d = 0;
		if (_isTimeBased) {
			d = Std.int(duration * 1000); // convert seconds to miliseconds
		} else {
			if (duration <= 0)
				duration = 0.1;
			d = Std.int(duration * FRAME_RATE); // seconds * FPS = frames
		}
		return d;
	}

	/**
	 * get time values
	 * TODO: I am forcing timer into Int... this works for JS, not sure for others
	 */
	function getTimer():Int {
		return Std.int(Date.now().getTime());
	}

	private function destroy():Void {
		if (Lambda.has(_tweens, this))
			_tweens.remove(this);
		// [mck] cleaning up
		if (_options) {
			_easing = Quad.easeOut;
			_options = cast {};
			_target = null;
			_props = null;
			_duration = 0;
			_initTime = 0;
			_delay = 0;
		}
	}
}

typedef Range = {key:String, from:Null<Float>, to:Null<Float>}
