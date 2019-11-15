package cc.util;

/**
 * Math related stuff is found here
 * 		- radians & convertions
 * 		- degree & convertions
 * 		- etc
 *
 * @example
 * ```
 * import cc.util.MathUtil;
 * MathUtil.random (10);
 *
 * // or
 *
 * import cc.util.MathUtil.*;
 * random(10); // make it easier to read
 * ```
 *
 */
class MathUtil {
	static public function radians(deg:Float):Float {
		return deg * Math.PI / 180;
	};

	static public function degrees(rad:Float):Float {
		return rad * 180 / Math.PI;
	};

	// public function rotateDegrees(deg) {
	// 	this.rotate(radians(deg));
	// }
	// public function rotateDeg(deg) {
	// 	this.rotate(radians(deg));
	// }
	static public function degreesToPoint(deg, diameter) {
		var rad = Math.PI * deg / 180;
		var r = diameter / 2;
		return {x: r * Math.cos(rad), y: r * Math.sin(rad)};
	}

	static public function distributeAngles(me, total) {
		return me / total * 360;
	}

	/**
	 * calculate distance between two point (x,y)
	 * @param x1	point 1, xpos
	 * @param y1	point 1, ypos
	 * @param x2	point 2, xpos
	 * @param y2	point 2, ypos
	 *
	 * @return  	distance between two points
	 */
	static public function distance(x1:Float, y1:Float, x2:Float, y2:Float):Float {
		return dist(x1, y1, x2, y2);
	}

	static public function dist(x1:Float, y1:Float, x2:Float, y2:Float) {
		x2 -= x1;
		y2 -= y1;
		return Math.sqrt((x2 * x2) + (y2 * y2));
	}

	/**
	 * [pythagoreanTheorem description]
	 *
	 * @example
	 * 			trace (MathUtil.pythagoreanTheorem(0, 5, 10)); // 8.66025403784439
	 *			trace (MathUtil.pythagoreanTheorem(8.66025403784439, 5, 0)); // 10
	 *			trace (MathUtil.pythagoreanTheorem(8.66025403784439, 0, 10)); // 5
	 *
	 * @param  a 	side A
	 * @param  b 	side B
	 * @param  c 	hypotenuse C
	 */
	public static function pythagoreanTheorem(a:Float = null, b:Float = null, c:Float = null):Float {
		if (a == null && b == null && c == null) {
			trace("Really? Perhaps you should use some data");
			return 0;
		}
		var value = 0.0;

		if (c == null || c == 0)
			value = Math.sqrt(a * a + b * b);
		if (a == null || a == 0)
			value = Math.sqrt(c * c - b * b);
		if (b == null || b == 0)
			value = Math.sqrt(c * c - a * a);

		return value;
	}

	/**
	 * calculate the circumference of a circle (omtrek)
	 * 	Omtrek = pi * diameter = 2 * pi * straal
	 *
	 * 	@example
	 * 		MathUtil.circumferenceCircle(10); // 62.83185307179586
	 *
	 * @param radius 			radius of circel
	 * @return Float			circumference
	 */
	static public function circumferenceCircle(radius:Float):Float {
		return Math.PI * radius * 2;
	}

	/**
	 * calculate the circumference of a circle (omtrek)
	 * 	Omtrek = pi * diameter = 2 * pi * straal
	 *
	 * 	@example
	 * 		MathUtil.circumference2RadiusCircle(62.83185307179586); // 10
	 *
	 * @param circumference 	circumference of cicle
	 * @return Float			radius circle
	 */
	static public function circumference2RadiusCircle(circumference:Float):Float {
		return circumference / (Math.PI * 2);
	}

	/**
	 * Oppervlakte = 1/4 * pi * diameter2 = pi * straal2
	 *
	 * 	@example
	 * 		MathUtil.areaCircle(10); // 62.83185307179586
	 *
	 * @param radius
	 * @return Float
	 */
	static public function areaCircle(radius:Float):Float {
		return Math.PI * Math.sqrt(radius);
	}

	/**
	 * Get a random number between `min` and `max`
	 *
	 * @example		cc.util.MathUtil.randomInteger(10,100); // producess an number between 10 and 100
	 *
	 * @param min 	minimum value
	 * @param max 	maximum value (optional: if not `max == min` and `min == 0` )
	 * @return Int	number between `min` and `max`
	 */
	static public function randomInteger(min:Int, ?max:Int):Int {
		if (max == null) {
			max = min;
			min = 0;
		}
		return Math.floor(Math.random() * (max + 1 - min)) + min;
	}

	static public function randomInt(min, ?max):Int {
		return randomInteger(min, max);
	}

	/**
	 * Get a random number between `min` and `max`
	 *
	 * @example		cc.util.MathUtil.random(10,100); // producess an number between 10 and 100
	 *
	 * @param min 	minimum value
	 * @param max 	maximum value
	 * @return Float	number between `min` and `max`
	 */
	static public function random(?min:Float, ?max:Float):Float {
		if (min == null) {
			min = 0;
			max = 1;
		} else if (max == null) {
			max = min;
			min = 0;
		}
		return (Math.random() * (max - min)) + min;
	};

	static public function randomP(?min:Float, ?max:Float) {
		if (min == null) {
			min = 0.1;
			max = 1;
		} else if (max == null) {
			max = min;
			min = 0.1;
		}
		return (Math.random() * (max - min)) + min;
	};

	/**
	 * not sure how this will work..
	 *
	 * what I want is chance(80) or chance(0.8)
	 * and get a 80% change for a true, otherwise false
	 * chance
	 * @param value a value between 0 and 1
	 */
	static public function chance(value:Float):Bool {
		if (value > 1)
			value /= 100;
		// return (random(value) > value - 1);
		return Math.random() < value;
	}

	/**
	 * get value 1 or -1
	 */
	static public function posNeg() {
		return randomInt(0, 1) * 2 - 1;
	}

	/**
	 * its either yes or no (true or false)
	 *
	 * @exampe 		trace(MathUtil.flip());
	 * @return Bool
	 */
	static public function flip():Bool {
		return Math.random() < 0.5;
	}

	/**
	 * calculate the angle between two point
	 * @param cx		center point x
	 * @param cy		center point y
	 * @param ex		end point x
	 * @param ey		end point y
	 * @return Float
	 */
	static public function angle(cx:Float, cy:Float, ex:Float, ey:Float):Float {
		var dy = ey - cy;
		var dx = ex - cx;
		var theta = Math.atan2(dy, dx); // range (-PI, PI]
		theta *= 180 / Math.PI; // rads to degs, range (-180, 180]
		if (theta < 0)
			theta = 360 + theta; // range [0, 360);
		if (theta == 360)
			theta = 0;
		return theta;
	}

	static public function map(value, min1, max1, min2, max2, clampResult) {
		var returnvalue = ((value - min1) / (max1 - min1) * (max2 - min2)) + min2;
		if (clampResult)
			return clamp(returnvalue, min2, max2);
		else
			return returnvalue;
	};

	/**
	 * get an orbit value: use a centerpoint and radius to create points around this centerpoint
	 *
	 *	@example
	 *		import cc.util.MathUtil;
	 *		var point = MathUtil.orbit (100,100,20, 360/4);
	 *		trace('${point.x} , ${point.y}');
	 *
	 *
	 * @param xpos center point x
	 * @param ypos center point y
	 * @param angle in degree (360)
	 * @param radius the radius of circle
	 * @return AST.Point
	 */
	static public function orbit(xpos:Float, ypos:Float, angle:Float, radius:Float):AST.Point {
		// plot the balls x to cos and y to sin
		var _xpos = xpos + Math.cos(radians(angle)) * radius;
		var _ypos = ypos + Math.sin(radians(angle)) * radius;
		return {x: _xpos, y: _ypos};
	}

	static public function orbitX(origin:Float, angle:Float, radius:Float):Float {
		return origin + Math.cos(radians(angle)) * radius;
	}

	static public function orbitY(origin:Float, angle:Float, radius:Float):Float {
		return origin + Math.sin(radians(angle)) * radius;
	}

	static public function orbitZ(origin:Float, angle:Float, radius:Float):Float {
		return origin + Math.cos(radians(angle)) * radius;
	}

	/**
	 * Randomly shuffle an array
	 * https://stackoverflow.com/a/2450976/1293256
	 * @param  {Array} array The array to shuffle
	 * @return {String}      The first item in the shuffled array
	 */
	static public function shuffle(array:Array<Dynamic>):Array<Dynamic> {
		var currentIndex = array.length;
		var temporaryValue, randomIndex;

		// While there remain elements to shuffle...
		while (0 != currentIndex) {
			// Pick a remaining element...
			randomIndex = Math.floor(Math.random() * currentIndex);
			currentIndex -= 1;

			// And swap it with the current element.
			temporaryValue = array[currentIndex];
			array[currentIndex] = array[randomIndex];
			array[randomIndex] = temporaryValue;
		}

		return array;
	};

	/**
	 * sent a value, and check if it is in the correct range
	 *
	 * @example
	 * 	 MathUtil.clamp(Math.round(r), 0, 255) // a value r should be between 0 and 255
	 *
	 * @param value		value to check
	 * @param min		minimum value
	 * @param max		maximum value
	 */
	static public function clamp(value, min, max) {
		return Math.min(Math.max(value, Math.min(min, max)), Math.max(min, max));
	}

	/**
		function xyz(px, py, pz, pitch, roll, yaw) {

		var cosa = Math.cos(yaw);
		var sina = Math.sin(yaw);

		var cosb = Math.cos(pitch);
		var sinb = Math.sin(pitch);

		var cosc = Math.cos(roll);
		var sinc = Math.sin(roll);

		var Axx = cosa*cosb;
		var Axy = cosa*sinb*sinc - sina*cosc;
		var Axz = cosa*sinb*cosc + sina*sinc;

		var Ayx = sina*cosb;
		var Ayy = sina*sinb*sinc + cosa*cosc;
		var Ayz = sina*sinb*cosc - cosa*sinc;

		var Azx = -sinb;
		var Azy = cosb*sinc;
		var Azz = cosb*cosc;

		x = Axx*px + Axy*py + Axz*pz;
		y = Ayx*px + Ayy*py + Ayz*pz;
		z = Azx*px + Azy*py + Azz*pz;

		return {x:x, y:y, z:z};
		}
	 */
}
