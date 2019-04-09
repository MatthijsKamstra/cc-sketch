package cc.tool.export;

interface IExportWrapper {
	// public function new(ctx:CanvasRenderingContext2D, ?fileName:String);
	public function type(type:ExportWrapper.ExportType):Void;
	public function init():Void;
	public function start():Void;
	public function record(frames:Int):Void;
	public function recordInSeconds(sec:Float):Void;
	public function delay(frames:Int):Void;
	public function delayInSeconds(sec:Float):Void;
	public function stop():Void;
	public function menu(isVisible:Bool = false):Void;
	public function debug(?isDebug:Bool):Void;
	public function onRecordStart(func:Dynamic, ?arr:Array<Dynamic>):Void;
	@:isVar public var _isDebug(get, set):Bool;
	public function onRecordComplete(func:Dynamic, ?arr:Array<Dynamic>):Void;
	public function onExportComplete(func:Dynamic, ?arr:Array<Dynamic>):Void;
	public function pulse():Void;
}
