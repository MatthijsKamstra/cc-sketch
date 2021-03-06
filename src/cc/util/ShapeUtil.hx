package cc.util;

import js.html.CanvasRenderingContext2D;
// import cc.Global.*;
import cc.util.ColorUtil.*;
import cc.AST;

// syntactic sugar to extend CanvasRenderingContext2D
using cc.CanvasTools;

/**
 * predefined shapes that are every useful
 * @example:
 * 		using cc.CanvasTools;
 */
class ShapeUtil {
	/**
	 * [Description]
	 * @param ctx
	 * @param x
	 * @param y
	 * @param width
	 * @param height
	 */
	static public function cross(ctx:CanvasRenderingContext2D, x:Float, y:Float, ?width:Float = 20, ?height:Float = 60) {
		ctx.colour(PINK.r, PINK.g, PINK.b, 1);
		ctx.fillRect(x - width / 2, y - height / 2, width, height);
		ctx.fillRect(x - height / 2, y - width / 2, height, width);
	}

	static public function registerPoint(ctx:CanvasRenderingContext2D, x:Float, y:Float) {
		var _w = 10;
		var _h = 10;
		var _d = 2;
		ctx.colour(PINK.r, PINK.g, PINK.b, 1);
		ctx.fillRect(x - _w / 2, y - (_d / 2), _w, _d);
		ctx.fillRect(x - (_d / 2), y - _h / 2, _d, _h);
		// ctx.fillCircle(x,y,10);

		// trace('xxx');
	}

	static public function colorRegisterPoint(ctx:CanvasRenderingContext2D, x:Float, y:Float, ?rgb:cc.util.ColorUtil.RGB) {
		if (rgb == null)
			rgb = PINK;
		var _w = 10;
		var _h = 10;
		var _d = 2;
		ctx.colourRGB(rgb, 1);
		ctx.fillRect(x - _w / 2, y - (_d / 2), _w, _d);
		ctx.fillRect(x - (_d / 2), y - _h / 2, _d, _h);
	}

	/**
	 * centered x-shape
	 *
	 * @example
	 * 		ctx.xcross(w/2, h/2, 100, 20);
	 *
	 * @param ctx
	 * @param x			x pos, center of x-shape
	 * @param y			y pos, center of x-shape
	 * @param size		(optional) size shape, default:200
	 * @param weight	(optional) stroke weight, default:100
	 */
	public static function xcross(ctx:CanvasRenderingContext2D, x:Float, y:Float, ?size:Float = 200, ?weight:Int = 100) {
		ctx.strokeWeight(weight);
		ctx.line(x - size / 2, y - size / 2, x - size / 2 + size, y - size / 2 + size);
		ctx.line(x + size - size / 2, y - size / 2, x - size / 2, y + size - size / 2);
	}

	/**
	 * use with de data of GridUtil
	 * @example
	 * 			var arr:Array<Point> = GridUtil.create(0, 0, w, h, 3, 4);
	 * 			cc.util.ShapeUtil.gridRegister(ctx, arr);
	 */
	public static function gridRegister(ctx:CanvasRenderingContext2D, arr:Array<Point>) {
		for (i in 0...arr.length) {
			var point:Point = arr[i];
			registerPoint(ctx, point.x, point.y);
		}
	}

	public static function gridRegisters(ctx:CanvasRenderingContext2D, grid:GridUtil) {
		for (i in 0...grid.array.length) {
			var point:Point = grid.array[i];
			cross(ctx, point.x, point.y, 5, 20);
		}
	}

	/**
	 * use with de data of GridUtil
	 * create registration point with a border of grid
	 * @example
	 * 			var grid = ...
	 * 			cc.util.ShapeUtil.gridField(ctx, grid);
	 */
	public static function gridField(ctx:CanvasRenderingContext2D, grid:GridUtil) {
		for (i in 0...grid.array.length) {
			var point:Point = grid.array[i];
			registerPoint(ctx, point.x, point.y);
		}
		ctx.lineWidth = 1;
		ctx.lineColour(GRAY.r, GRAY.g, GRAY.b, 0.5);
		ctx.strokeRect(grid.x, grid.y, grid.width, grid.height);
	}

	/**
	 * use with de data of GridUtil
	 * create dot point with a border of grid
	 * @example
	 * 			var grid = ...
	 * 			cc.util.ShapeUtil.gridDots(ctx, grid);
	 */
	public static function gridDots(ctx:CanvasRenderingContext2D, grid:GridUtil) {
		for (i in 0...grid.array.length) {
			var point:Point = grid.array[i];
			ctx.colour(PINK.r, PINK.g, PINK.b, 1);
			ctx.circle(point.x, point.y, 1);
		}
		ctx.lineWidth = 1;
		ctx.lineColour(GRAY.r, GRAY.g, GRAY.b, 0.5);
		ctx.strokeRect(grid.x, grid.y, grid.width, grid.height);
	}
}
