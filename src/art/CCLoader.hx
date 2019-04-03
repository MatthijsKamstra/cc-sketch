package art;

import cc.tool.Loader;

class CCLoader extends SketchBase {
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
		super(null);
	}

	override function setup() {
		trace('SETUP :: ${toString()}');

		Loader.create('name')
			.add('img/aaron-burden-38410-unsplash.jpg')
			.add('img/miguel-ibanez-643801-unsplash.jpg')
			.add('img/nathan-dumlao-526295-unsplash.jpg')
			.add('img/foobar.jpg')
			.onComplete(onCompleteHandler)
			.onUpdate(onUpdateHandler)
			.onProgress(onProgressHandler)
			.onError(onErrorHandler)
			.load();
	}

	function onCompleteHandler(completeArray:Array<LoaderObj>) {
		trace('onCompleteHandler: ' + completeArray.length);
	}

	function onUpdateHandler(e:js.html.ImageElement) {
		trace('onUpdateHandler: ' + e.src);
	}

	function onProgressHandler(e:js.html.ImageElement) {
		trace('onProgressHandler: ' + e);
	}

	function onErrorHandler(e:js.html.ImageElement) {
		trace('onErrorHandler: ' + e.src);
	}

	override function draw() {
		// trace('DRAW :: ${toString()}');
		// drawShape();
		// stop();
	}
}
