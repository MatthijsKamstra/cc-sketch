package art;

import js.Browser.*;
import js.html.*;
import Sketch;

class CC100 extends SketchBase {
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
		// setup Sketch
		var option = new SketchOption();
		option.width = 1080; // 1080
		// option.height = 1000;
		option.autostart = true;
		option.padding = 10;
		option.scale = true;
		var ctx:CanvasRenderingContext2D = Sketch.create("creative_code_mck", option);

		init();

		super(ctx);
	}

	function init() {
		dot = createShape(100, {x: w / 2, y: h / 2});
		// <link href="https://fonts.googleapis.com/css?family=Oswald:200,300,400,500,600,700" rel="stylesheet">
		FontUtil.embedGoogleFont('Oswald:200,300,400,500,600,700', onEmbedHandler);
		createQuickSettings();
		onAnimateHandler(dot);
	}

	function onEmbedHandler(e) {
		trace('onEmbedHandler :: ${toString()} -> "${e}"');
		drawShape();
	}

	function createQuickSettings() {
		// demo/basic example
		panel1 = QuickSettings.create(10, 10, "Settings")
			.setGlobalChangeHandler(untyped drawShape)

			.addHTML("Reason", "Sometimes I need to find the best settings")

			.addTextArea('Quote', 'text', function(value) trace(value))
			.addBoolean('All Caps', false, function(value) trace(value))

			.setKey('h') // use `h` to toggle menu

			.saveInLocalStorage('store-data-${toString()}');
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
		ctx.clearRect(0, 0, w, h);
		ctx.backgroundObj(WHITE);

		if (isDebug) {
			ShapeUtil.gridField(ctx, grid);
		}

		for (i in 0...shapeArray.length) {
			var sh = shapeArray[i];
		}
		// var rgb = randomColourObject();
		// ctx.strokeColour(rgb.r, rgb.g, rgb.b);
		// ctx.xcross(w/2, h/2, 200);

		ctx.fillStyle = getColourObj(_color4);
		FontUtil.centerFillText(ctx, 'text', w / 2, h / 2, "'Oswald', sans-serif;", 160);

		ctx.strokeColourRGB(_color3);
		ctx.strokeWeight(2);
		ctx.circleStroke(dot.x, dot.y, 20);
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
