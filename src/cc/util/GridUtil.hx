package cc.util;

import Sketch.Global.*;
import cc.AST;
import js.Browser.*;
import js.html.CanvasRenderingContext2D;
import cc.util.ColorUtil.RGB;

/**
 *
 * |-------------------------------|
 * |             row               |
 * |-------------------------------|
 *
 *
 * |--------|
 * |        |
 * |        |
 * |        |
 * | colomn |
 * |        |
 * |        |
 * |        |
 * |--------|
 *
 *
 * @example
 * 			var grid:GridUtil = new GridUtil();
 * 			grid.setNumbered(3,3); // 3 horizontal, 3 vertical
 * 			// grid.setCellSize(_cellsize); // use a cellsize (width/height)
 * 			grid.setIsCenterPoint(true); // default true, but can be set if needed
 *
 * 			// quick generate grid
 * 			if (isDebug) {
 * 				ShapeUtil.gridField(ctx, grid);
 * 				// util.TestUtil.gridDots(sketch, grid);
 * 			}
 *
 * 			// use grid to generate totale amount of shapes/etc
 * 			for (i in 0...grid.array.length) {
 * 				shapeArray.push(createShape(i, grid.array[i]));
 * 			}
 */
class GridUtil {
	public var array:Array<Point> = [];
	public var total:Int = null;

	/**
	 * starting point x
	 */
	public var x:Float = null;

	/**
	 * starting point y
	 */
	public var y:Float = null;

	/**
	 * the width of the grid
	 */
	public var width:Float = null;

	/**
	 * the height of the grid
	 */
	public var height:Float = null;

	public var gridX:Float = 0;
	public var gridY:Float = 0;

	/**
	 * create grid with center point as (gridw gridheight center)
	 */
	public var isCentered:Bool = false;

	/**
	 * use fullscreen or bigger to use a grid
	 */
	public var isFullscreen:Bool = false;

	/**
	 * how width is the grid
	 */
	public var cellWidth:Float = null;

	/**
	 * how height is the grid
	 */
	public var cellHeight:Float = null;

	/**
	 * number of horizontal items in the array
	 */
	public var numHor:Float = null;

	/**
	 * same as numHor, but a easier name to remember
	 */
	public var totalRow:Int = null;

	/**
	 * number of vertical items in the array
	 */
	public var numVer:Float = null;

	/**
	 * same as numVer, but a easier name to remember
	 */
	public var totalColumn:Int = null;

	var _isCellSize:Bool = false;
	var _isNumbered:Bool = false;
	var _isDimension:Bool = false;
	var _isPosition:Bool = false;
	var _isDebug:Bool = false; // fix ugly grid bugs

	// ____________________________________ chaining ____________________________________
	// not alway needed, can be used for svg
	private var _ctx:CanvasRenderingContext2D;

	// new private vars
	private var _x:Dynamic; //
	private var _y:Dynamic; //
	private var _w:Dynamic; //
	private var _h:Dynamic; //
	private var _hor:Dynamic; //
	private var _ver:Dynamic; //
	private var _cellw:Dynamic; //
	private var _cellh:Dynamic; //
	private var _center:Dynamic; //
	private var _debug:Dynamic; // (Suggestion: debug)
	private var _fullscreen:Dynamic; // (Suggestions: fullscreen, isFullscreen)
	private var _color:Dynamic; // (Suggestion: color)

	public function new(?ctx:CanvasRenderingContext2D) {
		if (ctx != null)
			this._ctx = ctx;
	}

	/**
	 * var grid = GridUtil.create(ctx).draw();
	 *
	 * @param ctx
	 * @param text
	 * @return GridUtil
	 */
	static inline public function create(ctx:CanvasRenderingContext2D):GridUtil {
		var GridUtil = new GridUtil(ctx);
		return GridUtil;
	}

	// ____________________________________ properties ____________________________________

	/**
	 * [mck] prefer to have this x, and y
	 *
	 * set the x position of the grid
	 *
	 * @param x 	start grid at ypos
	 * @return GridUtil
	 */
	inline public function xpos(x:Float):GridUtil {
		this._x = x;
		return this;
	}

	/**
	 * set the y position of the grid
	 * @param y 	start grid at ypos
	 * @return GridUtil
	 */
	inline public function ypos(y:Float):GridUtil {
		this._y = y;
		return this;
	}

	/**
	 * start position x and y
	 * @param x 	start grid at xpos
	 * @param y 	start grid at ypos
	 * @return GridUtil
	 */
	inline public function pos(x:Float, y:Float):GridUtil {
		this._x = x;
		this._y = y;
		return this;
	}

	/**
	 * use specific size of the grid
	 * @param w 	width in pixels
	 * @param h 	height in pixels
	 * @return GridUtil
	 */
	inline public function dimension(w:Float, h:Float):GridUtil {
		this._w = w;
		this._h = h;
		return this;
	}

	/**
	 * grid with horizontal (column) and vertical (rows)
	 * @param hor
	 * @param ver
	 * @return GridUtil
	 */
	inline public function grid(hor:Int, ver:Int):GridUtil {
		this._hor = hor;
		this._ver = ver;
		return this;
	}

	/**
	 * set the cell size of the grid
	 * @param w 	width of the cell
	 * @param h 	height of the cell
	 * @return GridUtil
	 */
	inline public function size(w:Float, h:Float):GridUtil {
		this._cellw = w;
		this._cellh = h;
		return this;
	}

	/**
	 * use a centered grid
	 * @return GridUtil
	 */
	inline public function centered():GridUtil {
		this._center = true;
		return this;
	}

	/**
	 * use to debug this class
	 * @return GridUtil
	 */
	inline public function debug():GridUtil {
		this._debug = true;
		return this;
	}

	/**
	 * doesn't work yet
	 * @return GridUtil
	 */
	inline public function fullscreen():GridUtil {
		this._fullscreen = true;
		return this;
	}

	/**
	 * doesn't work yet and no idea why?
	 * @return GridUtil
	 */
	inline public function color(value:RGB):GridUtil {
		this._color = value;
		return this;
	}

	/**
	 * doesn't work yet and no idea why?
	 * @return GridUtil
	 */
	inline public function calc():GridUtil {
		trace('WIP');
		return this;
	}

	/**
	 * not sure what it does, does it work?
	 * @return GridUtil
	 */
	inline public function draw(?isDebug:Bool = false):GridUtil {
		// draw on canvas
		if (isDebug) {
			// _ctx
		}
		return this;
	}

	/**
	 * start position x and y
	 * @param x 	start grid at xpos
	 * @param y 	start grid at ypos
	 */
	public function setPosition(x, y) {
		if (_isDebug)
			console.log('${toString()} setPostion');
		this.x = x;
		this.y = y;
		this._isPosition = true;
		calculate();
	}

	/**
	 * use centered point for grid
	 *
	 * @param isCentered  (default: true)
	 */
	public function setIsCenterPoint(isCentered:Bool = true) {
		if (_isDebug)
			console.log('${toString()} setCenterPoint');
		this.isCentered = isCentered;
		calculate();
	}

	/**
	 * use when want to debug the grid
	 *
	 * @param isDebug  (default = true)
	 */
	public function setDebug(isDebug:Bool = true) {
		this._isDebug = isDebug;
		if (_isDebug)
			console.log('${toString()} setDebug');
	}

	/**
	 * create a grid that is fullscreen, or bigger
	 *
	 * works with 	- cellsize (width/height)
	 * 				- numVer/numHer
	 *
	 * @param isFullscreen	(optional) default : true
	 */
	public function setIsFullscreen(isFullscreen:Bool = true) {
		if (_isDebug)
			console.log('${toString()} setIsFullscreen');
		this.isFullscreen = isFullscreen;
		calculate();
	}

	/**
	 * create a grid based upon width/height
	 * 		x, y, cellWidth, cellHeight is calculated
	 * @param width		total width of grid
	 * @param height	total height of grid
	 */
	public function setDimension(width:Float, height:Float) {
		if (_isDebug)
			console.log('${toString()} setDimension (width: ${width}, height: ${height})');
		this.width = width;
		this.height = height;
		this._isDimension = true;
		calculate();
	}

	/**
	 * create grid based upon horizontal and vertical blocks
	 * @param numHor	number of items horizontal (colums)
	 * @param numVer	number of items vertical (rows)
	 */
	public function setNumbered(numHor:Float, numVer:Float) {
		if (_isDebug)
			console.log('${toString()} setNumbers (numHor: ${numHor}, numVer: ${numVer})');
		this.numHor = numHor;
		this.numVer = numVer;
		this._isNumbered = true;
		calculate();
	}

	/**
	 * use these values to calculate the grid
	 * if this is only set, it will x, y, width, height of the grid
	 *
	 * center point is LEFT,TOP
	 *
	 * @param cellWidth 	fixed grid width
	 * @param cellHeight 	(optional) fixed grid height (default is equal to cellWidth)
	 */
	public function setCellSize(cellWidth:Float, ?cellHeight:Float) {
		if (cellHeight == null)
			cellHeight = cellWidth;
		if (_isDebug)
			console.log('${toString()} setCellSize (cellWidth: ${cellWidth}, cellHeight: ${cellHeight})');
		this.cellWidth = cellWidth;
		this.cellHeight = cellHeight;
		this._isCellSize = true;
		calculate();
	}

	/**
	 * in which row is this value
	 *
	 * @param sh
	 * @return Int
	 */
	public function row(sh:Point):Int {
		return getTablePosition(sh).row;
	}

	/**
	 * in which column is this value
	 * @param sh
	 * @return Int
	 */
	public function column(sh:Point):Int {
		return getTablePosition(sh).column;
	}

	/**
	 * get the row and column data of a point
	 *
	 * @example
	 * 			for (i in 0...grid.array.length) {
	 *				var sh = grid.array[i];
	 *				trace(grid.getTablePosition(sh).row);
	 *			}
	 *
	 * @param sh
	 * @return Dynamic
	 */
	public function getTablePosition(sh:Point):Dynamic {
		var index = array.indexOf(sh);
		var _row = Math.floor(index / numHor);
		var _column = index - (_row * numHor);
		return {"row": _row, "column": _column};
	}

	/**
	 * get the index of (no safety yet)
	 * @param point
	 * @return Int
	 */
	public function getIndex(point:Point):Int {
		var index = array.indexOf(point);
		if (index == -1)
			console.warn('Looks like this point (${point.x}, ${point.y}) is not in array');
		return index;
	}

	/**
	 * convert rows and column into a value in that table/grid
	 *
	 * @param row		if de grid would be a table, which row do you want
	 * @param column	if de grid would be a table, which column do you want
	 * @return Point
	 */
	public function getTablePoint(row:Int, column:Int):Point {
		// [mck] lets build in some clever messages
		if (row >= totalRow) {
			console.warn('looks like the row is outside the grid ($row >= $totalRow)');
			return null;
		}
		if (column >= totalColumn) {
			console.warn('looks like the column is outside the grid ($column >= $totalColumn)');
			return null;
		}
		if (row < 0) {
			console.warn('looks like the row is outside the grid ($row < 0)');
			return null;
		}
		if (column < 0) {
			console.warn('looks like the column is outside the grid ($column < 0)');
			return null;
		}
		return array[Math.round((row * numHor) + (column))];
	}

	public function reset() {
		array = []; // reset array
	}

	function calculate() {
		if (_isDebug)
			console.log('${toString()} calculate()');
		/**
		 * solution #1:
		 * grid is fixed via `cellWidth` and `cellHeight`
		 * calculate: `x`, `y`, `width`, `height`, `numHor`, `numVer`
		 *
		 * TOP/LEFT centerpoint?
		 */
		if (_isCellSize && !_isDimension) {
			if (_isDebug)
				console.info('${toString()} solution #1: cellSize is set');
			numHor = Math.floor(w / cellWidth);
			numVer = Math.floor(h / cellHeight);
			width = numHor * cellWidth;
			height = numVer * cellHeight;
			x = (w - width) / 2;
			y = (h - height) / 2;
		}

		/**
		 * solution #2:
		 * use numbered cells (in x-dir and y-dir),
		 * calculate: `x`, `y`, `width`, `height`, `cellWidth`, `cellHeight`
		 */
		if (_isNumbered && !_isDimension) {
			if (_isDebug)
				console.info('${toString()} solution #2: numbered cells set');
			var _w = (width != null) ? width : w;
			var _h = (height != null) ? height : h;
			// numHor = Math.floor(_w / cellWidth);
			// numVer = Math.floor(_h / cellHeight);
			cellWidth = _w / numHor;
			cellHeight = _h / numVer;
			width = numHor * cellWidth;
			height = numVer * cellHeight;
			x = (w - width) / 2;
			y = (h - height) / 2;

			console.info('cellWidth: $cellWidth, cellHeight: $cellHeight, width: $width, height: $height, x: $x, y: $y');
		}

		/**
		 * solution #3:
		 * use a grid with set `width` and `height`
		 * calculate: `x`, `y`, `numHor`, `numVer`, `cellWidth`, `cellHeight`
		 */
		if (_isDimension && !_isNumbered && !_isCellSize) {
			if (_isDebug)
				console.info('${toString()} solution #3: width/height set ($width, $height)');

			// is not set
			var _cellWidth = (cellWidth != null) ? cellWidth : 50;
			var _cellHeight = (cellHeight != null) ? cellHeight : 50;
			// now we can calculate the number of rows/cols
			numHor = Math.floor(width / _cellWidth);
			numVer = Math.floor(height / _cellHeight);
			// because we can't have half a row, we need to recalculate the width/heigth
			width = numHor * _cellWidth;
			height = numVer * _cellHeight;
			// and now the width and height might have changed, so does the cells
			cellWidth = width / numHor;
			cellHeight = height / numVer;
			// centered everything
			x = (w - width) / 2;
			y = (h - height) / 2;
		}

		/**
		 * solution #3a:
		 * use a grid with set `width`, `height` AND `numHor`, `numVer`
		 * calculate: `x`, `y`, `cellWidth`, `cellHeight`
		 */
		if (_isDimension && !_isCellSize) {
			if (_isDebug)
				console.info('${toString()} solution #3a: width/height set ($width, $height) AND number row/cols ($numHor, $numVer)');

			// is not set, calculate
			cellWidth = Math.floor(width / numHor); // make it round numbers
			cellHeight = Math.floor(height / numVer); // make it round numbers
			// because we can't have half a row, we need to recalculate the width/heigth
			width = numHor * cellWidth;
			height = numVer * cellHeight;
			if (!this._isPosition) {
				// centered everything
				x = (w - width) / 2;
				y = (h - height) / 2;
			}
		}

		/**
		 * solution #3b:
		 * use a grid with set `width`, `height` AND `numHor`, `numVer`
		 * calculate: `x`, `y`, `cellWidth`, `cellHeight`
		 */
		if (_isDimension && _isNumbered && !_isCellSize) {
			if (_isDebug) {
				console.info('${toString()} solution #3b: w/h set ($width, $height) AND number row/cols ($numHor, $numVer)');
				console.info('${toString()}  ($w, $h)');
			}

			// is not set, calculate
			cellWidth = Math.floor(width / numHor); // make it round numbers
			cellHeight = Math.floor(height / numVer); // make it round numbers
			// because we can't have half a row, we need to recalculate the width/heigth
			width = numHor * cellWidth;
			height = numVer * cellHeight;
			// if(	!this._isPosition) {
			// 	// centered everything
			// 	x = (w - width) / 2;
			// 	y = (h - height) / 2;
			// }
		}

		/**
		 * solution #4:
		 * size of the cell is known, and width and height
		 * calculate: `x`, `y`, `width`, `height`, `cellWidth`, `cellHeight`
		 */
		if (_isCellSize && _isDimension) {
			if (_isDebug)
				console.info('${toString()} solution #4: cellSize is set and width/height');
			numHor = Math.floor(width / cellWidth);
			numVer = Math.floor(height / cellHeight);

			width = numHor * cellWidth;
			height = numVer * cellHeight;

			// [mck] cellwidth will be leading, so the width and height will be fixed accordingly
			if (!_isPosition) {
				x = (w - width) / 2;
				y = (h - height) / 2;
			}
		}

		if (isFullscreen && _isCellSize) {
			if (_isDebug)
				console.info('${toString()} solution #5: fullscreen and cellSize is set');

			width = w;
			height = h;

			// round up
			numHor = Math.ceil(width / cellWidth);
			numVer = Math.ceil(height / cellHeight);

			// calculate again, based upon numHor/numVer
			width = numHor * cellWidth;
			height = numVer * cellHeight;

			x = (w - width) / 2;
			y = (h - height) / 2;
		}

		var cx = 0.0;
		var cy = 0.0;
		if (isCentered) {
			cx = cellWidth / 2;
			cy = cellHeight / 2;
		}

		array = []; // reset array
		var total = Math.round(numHor * numVer);
		var xpos = 0;
		var ypos = 0;
		for (i in 0...total) {
			var point:Point = {
				x: Math.round(x + (xpos * cellWidth) + cx),
				y: Math.round(y + (ypos * cellHeight) + cy),
			}
			array.push(point);
			xpos++;
			if (xpos >= numHor) {
				xpos = 0;
				ypos++;
			}
		}

		total = array.length; // just to have easy access to the array lentth
		if (_isDebug) {
			console.groupCollapsed('${toString()} Sata');
			console.log('x: $x, y: $y, width: $width, height: $height, cellWidth: $cellWidth, cellHeight: $cellHeight, numHor: $numHor, numVer: $numVer, array: ${array.length}');
			console.table(array);
			console.groupEnd();
		}

		totalRow = Math.round(numVer);
		totalColumn = Math.round(numHor);
	}

	/**
	 * old gridtools, renamed it from GridUtil.create to GridUtil.createGrid
	 *
	 * @param x			start position x
	 * @param y			start postion y
	 * @param width		width of grid
	 * @param height	height of grid
	 * @param numHor	number of items horizontal
	 * @param numVer	number of itmes vertical
	 */
	static public function createGrid(x:Float, y:Float, width:Float, height:Float, numHor:Int = 1, numVer:Int = 1):Array<Point> {
		// trace( x, y, width, height, numHor, numVer);
		var gridW = width / (numHor - 1);
		var gridH = height / (numVer - 1);
		var total = numHor * numVer;
		var xpos = 0;
		var ypos = 0;
		var arr:Array<Point> = [];
		for (i in 0...total) {
			var point:Point = {
				x: x + (xpos * gridW),
				y: y + (ypos * gridH),
			}
			arr.push(point);
			xpos++;
			if (xpos >= numHor) {
				xpos = 0;
				ypos++;
			}
		}
		return arr;
	}

	/**
	 *
	 * @param x
	 * @param y
	 * @param width
	 * @param height
	 * @param gridX
	 * @param gridY
	 * @param numHor
	 * @param numVer
	 * @return GridUtil
	 */
	static public function calcGrid(?x:Float = -1, ?y:Float = -1, ?width:Float = -1, ?height:Float = -1, ?gridX:Float = 1, ?gridY:Float = 1, ?numHor:Int = 1,
			?numVer:Int = 1):GridUtil {
		var grid = new GridUtil();
		grid.array = [];
		grid.x = 0;
		grid.y = 0;
		grid.width = 0;
		grid.height = 0;
		grid.gridX = 0;
		grid.gridY = 0;
		return grid;
	}

	function toString():String {
		return '[GridUtil]';
	}
}
