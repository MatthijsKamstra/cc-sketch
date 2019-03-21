package js;

import haxe.extern.EitherType;
import js.html.ArrayBuffer;
import js.html.Uint8Array;
//
import js.jszip.*;
import js.Promise;

// import js.node.Buffer;
// typedef DataType = EitherType<String, EitherType<ArrayBuffer, EitherType<Uint8Array, Buffer>>>;
typedef DataType = EitherType<String, EitherType<ArrayBuffer, EitherType<js.html.ImageData, Uint8Array>>>;

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
	@:overload(function(ereg:js.RegExp):Array<ZipObject> {})
	function file(name:String):Null<ZipObject>;
	@:overload(function(ereg:js.RegExp):Array<ZipObject> {})
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
	function generateAsync(obj:Dynamic):Promise<Dynamic>;
}
