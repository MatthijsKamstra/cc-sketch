package cc.util;

// http://www.independent-software.com/determining-coordinates-on-a-html-canvas-bezier-curve.html
class CurveUtil {
	/**
	 * Calculating coordinates along a cubic bézier curve in JavaScript
	 *
	 * @example 	var coord = getBezierXY(0.5, 0, 0, 60, 80, 40, 20, 100, 100);
	 *
	 * @param t		The t symbol, meanwhile, goes from 0 to 1 and determines how far we are along the curve. For t=0, B will be the start coordinate, for t=1, B will be the end coordinate, and for t=0.5, B will be the coordinate exactly halfway the curve.
	 * @param sx	start x
	 * @param sy	start y
	 * @param cp1x	controle point 1 x
	 * @param cp1y	controle point 1 y
	 * @param cp2x	controle point 2 x
	 * @param cp2y 	controle point 2 y
	 * @param ex	end x
	 * @param ey	end y
	 *
	 * @return 	cc.AST.Point : {x, y}
	 */
	function getBezierXY(t, sx, sy, cp1x, cp1y, cp2x, cp2y, ex, ey):cc.AST.Point {
		return {x: Math.pow(1 - t, 3) * sx + 3 * t * Math.pow(1 - t, 2) * cp1x + 3 * t * t * (1 - t) * cp2x + t * t * t * ex,
			y: Math.pow(1 - t, 3) * sy
			+ 3 * t * Math.pow(1 - t, 2) * cp1y
			+ 3 * t * t * (1 - t) * cp2y
			+ t * t * t * ey};
	}

	/**
	 * Calculating coordinates along a cubic bézier curve in JavaScript
	 *
	 * @example		var coord = getQuadraticXY(0.5, 0, 0, 60, 80, 100, 100);
	 *
	 * @param t		The t symbol, meanwhile, goes from 0 to 1 and determines how far we are along the curve. For t=0, B will be the start coordinate, for t=1, B will be the end coordinate, and for t=0.5, B will be the coordinate exactly halfway the curve.
	 * @param sx	start x
	 * @param sy	start y
	 * @param cp1x	controle point 1 x
	 * @param cp1y	controle point 1 y
	 * @param ex	end x
	 * @param ey	end y
	 *
	 * @return 	cc.AST.Point : {x, y}
	 */
	function getQuadraticXY(t, sx, sy, cp1x, cp1y, ex, ey):cc.AST.Point {
		return {
			x: (1 - t) * (1 - t) * sx + 2 * (1 - t) * t * cp1x + t * t * ex,
			y: (1 - t) * (1 - t) * sy + 2 * (1 - t) * t * cp1y + t * t * ey
		};
	}

	/**
	 * Calculating the curve angle anywhere along a cubic bézier curve
	 *
	 * @param t		The t symbol, meanwhile, goes from 0 to 1 and determines how far we are along the curve. For t=0, B will be the start coordinate, for t=1, B will be the end coordinate, and for t=0.5, B will be the coordinate exactly halfway the curve.
	 * @param sx	start x
	 * @param sy	start y
	 * @param cp1x	controle point 1 x
	 * @param cp1y	controle point 1 y
	 * @param cp2x	controle point 2 x
	 * @param cp2y 	controle point 2 y
	 * @param ex	end x
	 * @param ey	end y
	 *
	 * @return		the angle (in radians) between the bézier curve and the horizontal x-axis at point t.
	 */
	function getBezierAngle(t, sx, sy, cp1x, cp1y, cp2x, cp2y, ex, ey):Float {
		var dx = Math.pow(1 - t, 2) * (cp1x - sx) + 2 * t * (1 - t) * (cp2x - cp1x) + t * t * (ex - cp2x);
		var dy = Math.pow(1 - t, 2) * (cp1y - sy) + 2 * t * (1 - t) * (cp2y - cp1y) + t * t * (ey - cp2y);
		return -Math.atan2(dx, dy) + 0.5 * Math.PI;
	}

	/**
	 * Calculating the curve angle anywhere along a quadratic bézier curve
	 *
	 * @param t		The t symbol, meanwhile, goes from 0 to 1 and determines how far we are along the curve. For t=0, B will be the start coordinate, for t=1, B will be the end coordinate, and for t=0.5, B will be the coordinate exactly halfway the curve.
	 * @param sx	start x
	 * @param sy	start y
	 * @param cp1x	controle point 1 x
	 * @param cp1y	controle point 1 y
	 * @param ex	end x
	 * @param ey	end y
	 *
	 * @return		the angle (in radians) between the bézier curve and the horizontal x-axis at point t.
	 */
	function getQuadraticAngle(t, sx, sy, cp1x, cp1y, ex, ey):Float {
		var dx = 2 * (1 - t) * (cp1x - sx) + 2 * t * (ex - cp1x);
		var dy = 2 * (1 - t) * (cp1y - sy) + 2 * t * (ey - cp1y);
		return -Math.atan2(dx, dy) + 0.5 * Math.PI;
	}
}
