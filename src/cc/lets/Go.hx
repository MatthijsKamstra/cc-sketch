package cc.lets;

import cc.lets.Easing;
import haxe.Timer;
import cc.lets.easing.Quad;
import cc.lets.easing.IEasing;
import js.Browser.*;

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
	private var _isTimeBased:Bool = false; // default is frameBased
	private var _initTime:Int = 0; // should work with time (miliseconds) and frames (FPS)
	private var _delay:Int = 0;
	private var _seconds:Float = 0;
	private var FRAME_RATE:Int = 60; // 60 frames per second (FPS)
	private var DEBUG:Bool = false;
	private var VERSION:String = '1.0.6';

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
	 *
	  	 * @example		Go.to(foobarMc, 1.5).yoyo();
	 *
	 * @return       Go
	 */
	inline public function yoyo():Go {
		_isYoyo = true;
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

		// trace()

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
		// _options.onCompleteParams = (arr == null ) ? [] : arr;
		return this;
	}

	/**
	 * on update of the animation call a function with param(s)
	 *
	 * @param  func         	function to call when animition is updated
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
				return null;
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
			return null;
		}

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
			Reflect.callMethod(func, func, arr);
		}
		// [mck] for some reason this can be null
		if (_props == null)
			return;
		for (n in _props.keys()) {
			var range = _props.get(n);
			// Reflect.setProperty(_target, n, _easing(time / _duration) * (range.to - range.from) + range.from);
			Reflect.setProperty(_target, n, _easing.ease(time, range.from, (range.to - range.from), _duration));
		}
		// else throw( "Property "+propertyName+" not found in target!" );
	}

	private function complete():Void {
		if (DEBUG)
			trace('complete :: "$_id", _duration: $_duration, _seconds: $_seconds, _initTime: ' + _initTime + ' / _tweens.length: ' + _tweens.length);

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
			return null;
		}

		var func = _options.onComplete;
		var arr = (_options.onCompleteParams != null) ? _options.onCompleteParams : [];

		destroy();

		if (Reflect.isFunction(func))
			Reflect.callMethod(func, func, arr);
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
			if(duration <= 0) duration = 0.1;
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