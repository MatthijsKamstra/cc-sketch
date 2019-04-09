package cc.tool.export;

class ExportNone extends ExportWrapperBase implements IExport {
	public function new() {
		super();
		// trace(toString());
	}

	// ____________________________________ public functions ____________________________________
	public function export(obj:ExportWrapper.ExportWrapperObj):Void {
		haxe.Timer.delay(function() {
			_progress(25);
		}, 250);
		haxe.Timer.delay(function() {
			_progress(50);
		}, 500);
		haxe.Timer.delay(function() {
			_progress(75);
		}, 750);
		haxe.Timer.delay(function() {
			_progress(100);
		}, 1000);
		haxe.Timer.delay(function() {
			_complete(100);
		}, 1000);
	}

	// ____________________________________ calls ____________________________________

	function _progress(value:Float) {
		if (Reflect.isFunction(_onProgressHandler)) {
			trace('onProgressHandler ($value)');
			Reflect.callMethod(_onProgressHandler, _onProgressHandler, [value]);
		}
	}

	function _complete(value:Float) {
		if (Reflect.isFunction(_onExportComplete)) {
			trace('onExportComplete ($value)');
			Reflect.callMethod(_onExportComplete, _onExportComplete, []);
		}
	}

	override public function toString():String {
		return '[Export via TEST/NONE]';
	}
}
