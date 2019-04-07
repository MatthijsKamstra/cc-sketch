package art;

import js.Browser.*;
import js.html.*;
import Sketch;
import cc.model.constants.App;
import cc.tool.ExportFile;

class TestGo extends SketchBase {
	// settings
	var panel1:QuickSettings;
	// animate
	var dot:Circle;
	var dot2:Circle;
	var dot3:Circle;
	var _radius = 50;

	public function new() {
		init();
		super(null);
	}

	function init() {
		dot = createShape(100, {x: w / 2, y: h / 2});
		dot2 = createShape(100, {x: w / 2, y: h / 2});
		dot3 = createShape(100, {x: w / 2, y: h / 2});

		Go.wiggle(dot2, w2, h2, 50);
		Go.orbit(dot3, w2, h2, 50, 2);
		// createQuickSettings();
		onAnimateHandler(dot);
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
			.arc()
			.ease(Sine.easeInOut)
			.onComplete(onAnimateHandler, [obj]);
	}

	function drawShape() {
		ctx.clearRect(0, 0, w, h);
		ctx.backgroundObj(WHITE);

		ctx.strokeColourRGB(BLACK);
		ctx.strokeWeight(2);
		ctx.circleStroke(dot.x, dot.y, 20);

		ctx.strokeColourRGB(RED);
		ctx.circleStroke(dot2.x, dot2.y, 100);

		ctx.strokeColourRGB(GREEN);
		ctx.circleStroke(dot3.x, dot3.y, 50);
	}

	override function setup() {
		trace('SETUP :: ${toString()}');

		isDebug = true;
	}

	override function draw() {
		// trace('DRAW :: ${toString()}');
		drawShape();
		// stop();
	}
}
