package cc.tool.export;

import js.html.CanvasRenderingContext2D;
import cc.tool.export.ExportWrapper;
import Sketch;

/**
 * import import cc.tool.export.ExportBase;
 *
 * extends ExportBase
 *
 * // override default ExportWrapper settings
 *
 * export.delayInSeconds(2);
 * export.recordInSeconds(2);
 * export.isDebug(false);
 * export.type(ExportType.NODE);
 * trace(export.settings()); // get the settings
 * export.start(); // you always need to set this
 */
class ExportBase extends SketchBase {
	public var export:ExportWrapper;

	var imageStringArray:Array<String> = [];
	var _isDebug:Bool = false;

	/**
	 * constructor
	 * @param ctx
	 */
	public function new(ctx:CanvasRenderingContext2D) {
		// create a default export wrappers
		export = new ExportWrapper(ctx, toString());
		export.delay(0); // no delay
		export.recordInSeconds(10); // record 10 seconds default
		export.menu(false);
		export.type(ExportType.NONE); // ExportType.NODE
		export.onRecordStart(onRecordStartHandler);
		export.onRecordComplete(onRecordCompleteHandler);
		export.onExportComplete(onExportCompleteHandler);
		super(ctx);
	}

	function onRecordStartHandler() {
		if (export._isDebug)
			trace('${toString()} onRecordStartHandler');
	}

	function onRecordCompleteHandler() {
		if (export._isDebug)
			trace('${toString()} onRecordCompleteHandler');
		stop(); // stop animation during export, specialy usefull for zip export
	}

	function onExportCompleteHandler() {
		if (export._isDebug)
			trace('${toString()} onExportCompleteHandler');
		start(); // start animation after export
	}

	/**
	 * ctivate logs
	 * @param isDebug (default is `false`)
	 */
	public function debug(?isDebug:Bool = false) {
		this._isDebug = isDebug;
	}

	/**
	 * little hack in SketchBase to get this working...
	 * shhh it's our little secret
	 */
	override function __export() {
		export.pulse();
	}
}
