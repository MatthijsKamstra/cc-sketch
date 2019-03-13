package cc.model.constants;

class Sizes {
	public var INSTA_SQUARE_VIDEO:SizeObj = {
		width: 1080,
		height: 1080,
		dpi: 72,
		description: 'Instagram square video'
	};
	public var INSTAGRAM:Array<SizeObj> = [];
	public var APAPER:Array<SizeObj> = [];

	public function new() {
		INSTAGRAM = [INSTA_SQUARE_VIDEO];
	}
}

typedef SizeObj = {
	@:optional var _id:Int;
	var width:Float;
	var height:Float;
	var dpi:Int;
	var description:String;
};
