package cc.tool.export;

interface IExportWrapper {
	/**
	 * recording type, ZIP or NODE
	 * @param type
	 */
	public function type(type:ExportWrapper.ExportType):Void;

	/**
	 * set everything with the settings
	 * @param obj
	 */
	public function setting(obj:ExportWrapper.ExportSettings):Void;

	/**
	 * init everything, same effect as start
	 */
	public function init():Void;

	/**
	 * start recording now (remove delay, )
	 */
	public function start():Void;

	/**
	 * [Description]
	 */
	public function startRecording():Void;

	/**
	 * recording time in frames (fps)
	 * @param frames
	 */
	public function record(frames:Int):Void;

	/**
	 * recording time in seconds
	 * @param sec
	 */
	public function recordInSeconds(sec:Float):Void;

	/**
	 * delay recording in frames (fps)
	 * @param frames
	 */
	public function delay(frames:Int):Void;

	/**
	 * delay recording in seconds
	 * @param sec
	 */
	public function delayInSeconds(sec:Float):Void;
	public function stop():Void;
	public function menu(isVisible:Bool = false):Void;
	public function debug(?isDebug:Bool):Void;
	public function onRecordStart(func:Dynamic, ?arr:Array<Dynamic>):Void;
	public function onRecordComplete(func:Dynamic, ?arr:Array<Dynamic>):Void;
	public function onExportComplete(func:Dynamic, ?arr:Array<Dynamic>):Void;
	public function pulse():Void;
	@:isVar public var _isDebug(get, set):Bool;
	public function toExportObj():ExportWrapper.ExportWrapperObj;
}
