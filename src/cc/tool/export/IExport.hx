package cc.tool.export;

interface IExport {
	public function export(obj:ExportWrapper.ExportWrapperObj):Void;
	public function exportLite(fileName:String, imageStringArray:Array<String>):Void;
	public function progress(func:Float->Void):Void;
	public function complete(func:Dynamic):Void;
	public function debug(isDebug:Bool):Void;
	public function toString():String;
}
