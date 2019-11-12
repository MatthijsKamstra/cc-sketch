package js;

import haxe.extern.EitherType;
import js.html.ArrayBuffer;
import js.html.Uint8Array;
import haxe.Constraints.Function;
//
import js.jszip.*;
import js.Promise;

// import js.node.Buffer;
// typedef DataType = EitherType<String, EitherType<ArrayBuffer, EitherType<Uint8Array, Buffer>>>;
typedef DataType = EitherType<String, EitherType<js.lib.ArrayBuffer, EitherType<js.html.ImageData, js.lib.Uint8Array>>>;

@:native("JSZip")
extern class JSZip {
	static var support:{
		arraybuffer:Bool,
		uint8array:Bool,
		blob:Bool,
		nodebuffer:Bool
	};
	@:overload(function(data:DataType, options:LoadOptions):Void {})
	@:overload(function(data:DataType):Void {})
	function new():Void;
	@:overload(function(data:DataType, options:LoadOptions):Void {})
	function load(data:DataType):Void;
	@:overload(function(name:String, data:DataType, options:FileOptions):JSZip {})
	@:overload(function(name:String, data:DataType):JSZip {})
	@:overload(function(ereg:js.lib.RegExp):Array<ZipObject> {})
	function file(name:String):Null<ZipObject>;
	@:overload(function(ereg:js.lib.RegExp):Array<ZipObject> {})
	function folder(name:String):JSZip;
	function filter(predicate:String->ZipObject->Bool):Array<ZipObject>;
	/*
		Delete a file or folder (recursively).
	 */
	function remove(name:String):JSZip;
	/*
		Generates the complete zip file.
	 */
	function generate(options:GenerateOptions):DataType;
	//
	@:overload(function(obj:Dynamic, updateCallback:Function):js.lib.Promise<Dynamic> {})
	function generateAsync(obj:Dynamic):js.lib.Promise<Dynamic>;
}
