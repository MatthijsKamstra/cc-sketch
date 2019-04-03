package art;

import cc.tool.export.ExportBase;

class TestExport extends ExportBase {
	var shapeArray:Array<Circle> = [];
	var grid:GridUtil = new GridUtil();
	// sizes
	var _radius = 150;
	var _cellsize = 150;
	// colors
	var _color0:RGB = null;
	var _color1:RGB = null;
	var _color2:RGB = null;
	var _color3:RGB = null;
	var _color4:RGB = null;
	// settings
	var panel1:QuickSettings;
	// animate
	var dot:Circle;

	public function new() {
		var option = new SketchOption();
		option.width = 1080; // 1080
		// option.height = 1000;
		option.autostart = true;
		option.padding = 10;
		option.scale = true;
		ctx = Sketch.create("creative_code_mck", option);

		super(ctx);

		init();
	}

	function init() {
		// override wrapper settings,
		export.delayInSeconds(2);
		export.recordInSeconds(2);
		export.type(NODE);
		// export.type(TEST);
		export.isDebug(false);
		trace(export.settings()); // get the settings
		export.start(); // you always need to set this

		// create a dot
		dot = createShape(100, {x: w / 2, y: h / 2});
		// trace(new cc.model.constants.Sizes().INSTAGRAM);
		onAnimateHandler(dot);
	}

	function createShape(i:Int, ?point:Point) {
		var shape:Circle = {
			_id: '$i',
			_type: 'circle',
			x: point.x,
			y: point.y,
			radius: _radius,
		}
		// onAnimateHandler(shape);
		return shape;
	}

	function onAnimateHandler(obj:Circle) {
		var padding = 50;
		var time = random(1, 2);
		var xpos = random(padding, w - (2 * padding));
		var ypos = random(padding, h - (2 * padding));
		Go.to(obj, time)
			.x(xpos)
			.y(ypos)
			.ease(Sine.easeInOut)
			.onComplete(onAnimateHandler, [obj]);
	}

	function drawShape() {
		if (dot == null)
			return;

		ctx.clearRect(0, 0, w, h);
		ctx.backgroundObj(WHITE);

		if (isDebug) {
			ShapeUtil.gridField(ctx, grid);
		}

		for (i in 0...shapeArray.length) {
			var sh = shapeArray[i];
		}
		var rgb = randomColourObject();
		ctx.strokeColour(rgb.r, rgb.g, rgb.b);
		ctx.xcross(w / 2, h / 2, 200);

		// ctx.fillStyle = getColourObj(_color4);
		// Text.fillText(ctx, 'text', w / 2, h / 2, "'Oswald', sans-serif;", 160);

		ctx.strokeColourRGB(_color3);
		ctx.strokeWeight(100);
		ctx.circleStroke(dot.x, dot.y, 100);
	}

	override function setup() {
		trace('SETUP :: ${toString()}');

		var colorArray = ColorUtil.niceColor100SortedString[randomInt(ColorUtil.niceColor100SortedString.length - 1)];
		_color0 = hex2RGB(colorArray[0]);
		_color1 = hex2RGB(colorArray[1]);
		_color2 = hex2RGB(colorArray[2]);
		_color3 = hex2RGB(colorArray[3]);
		_color4 = hex2RGB(colorArray[4]);

		isDebug = true;

		// grid.setDimension(w*2.1, h*2.1);
		// grid.setNumbered(3,3);
		grid.setCellSize(_cellsize);
		grid.setIsCenterPoint(true);

		shapeArray = [];
		for (i in 0...grid.array.length) {
			shapeArray.push(createShape(i, grid.array[i]));
		}
	}

	override function draw() {
		// trace('DRAW :: ${toString()}');
		drawShape();
		// stop();
	}
}
