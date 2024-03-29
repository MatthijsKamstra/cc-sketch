package cc;

import cc.util.ColorUtil;

class AST {}

// ____________________________________ extending typedef ____________________________________
enum abstract ShapeType(String) {
	var CIRCLE = 'circle';
	var RECTANGLE = 'rectangle';
	var SQUARE = 'square';
}

typedef Base = {
	@:optional var _id:String;
	@:optional var _type:String; // make possible to switch draw
	// [mck] perhaps enum? ShapeType
}

typedef Dimensions = {
	@:optional var width:Float;
	@:optional var height:Float;
	@:optional var rotation:Float; // not sure about this
	@:optional var scale:Float; // not sure about this
};

typedef Position = {
	var x:Float;
	var y:Float;
};

typedef Appearance = {
	@:optional var color:Int;
	@:optional var colour:String;
	@:optional var alpha:Float;
	@:optional var rgb:RGB;
	@:optional var rgba:RGBA;
};

typedef Rotation = {
	@:optional var angle:Float;
	@:optional var startAngle:Float;
	@:optional var endAngle:Float;
	@:optional var speed:Float;
	@:optional var rotation:Float;
};

// point
typedef Point = {
	@:optional var type:String;
	var x:Float;
	var y:Float;
};

// point
typedef PointInt = {
	@:optional var type:String;
	var x:Int;
	var y:Int;
};

// ____________________________________ shape typedef  ____________________________________

typedef Pixel = {
	> Base,
	> Position,
	> Appearance,
}

typedef Polygon = {
	> Base,
	> Position,
	> Appearance,
	> Rotation,
	@:optional var radius:Float;
	@:optional var size:Float;
	@:optional var sides:Int;
};

typedef CircleExtra = {
	> Base,
	> Position,
	> Appearance,
	> Rotation,
	> Dimensions,
	@:optional var radius:Float;
	@:optional var size:Float;
};

typedef Circle = {
	> Base,
	> Position,
	> Appearance,
	@:optional var radius:Float;
	@:optional var size:Float;
};

typedef Arc = {
	> Base,
	> Position,
	> Appearance,
	> Rotation,
	@:optional var radius:Float;
	@:optional var size:Float;
};

typedef Oval = {
	> Base,
	> Position,
	> Appearance,
	> Dimensions,
};

typedef Square = {
	> Base,
	> Position,
	> Appearance,
	> Rotation,
	@:optional var rotation:Float;
	@:optional var size:Float; // width and height are the same
}

typedef Rectangle = {
	> Base,
	> Position,
	> Appearance,
	> Dimensions,
};

typedef LineNew = {
	> Base,
	> Appearance,
	var x1:Float;
	var y1:Float;
	var x2:Float;
	var y2:Float;
	@:optional var point1:Point;
	@:optional var point2:Point;
	@:optional var pointArray:Array<Point>;
	@:optional var lineWeight:Int;
	@:optional var strokeColor:Int;
	@:optional var strokeWeight:Int;
	@:optional var lineEnd:String;
};

// create a Ball typedef
typedef Ball = {
	> Circle,
	var speed_x:Float;
	var speed_y:Float;
};

// create a Line typedef
typedef Line = {
	@:optional var _type:String; // make possible to switch draw
	@:optional var _id:Int;
	var x1:Float;
	var y1:Float;
	var x2:Float;
	var y2:Float;
	@:optional var stroke:Int;
	@:optional var colour:String;
	@:optional var radius:Float;
};

typedef AnimateObj = {
	@:optional var _id:Int;
	@:optional var x:Float;
	@:optional var y:Float;
	@:optional var size:Float;
	@:optional var color:String;
	@:optional var width:Int;
	@:optional var height:Int;
	@:optional var rotation:Int;
	@:optional var alpha:Float;
	@:optional var type:String; // make possible to switch draw
};

// ____________________________________ export typedef ____________________________________

typedef EXPORT_MESSAGE = {
	> Base,
	var message:String;
};

typedef EXPORT_FRAME = {
	> Base,
	var file:String;
	@:optional var frame:Int;
	@:optional var name:String;
	@:optional var folder:String;
};

typedef EXPORT_IMAGE = {
	> Base,
	var file:String;
	var name:String;
	var folder:String;
	@:optional var exportFolder:String;
	// @:optional var name:String;
	// @:optional var folder:String;
	// @:optional var exportFolder:String;
};

typedef EXPORT_MD = {
	> Base,
	var name:String;
	var content:String;
	@:optional var folder:String;
	@:optional var exportFolder:String;
};

typedef EXPORT_FILE = {
	> Base,
	var name:String;
	var content:String;
	@:optional var folder:String;
	@:optional var exportFolder:String;
};

typedef EXPORT_CONVERT_VIDEO = {
	> Base,
	var name:String;
	var folder:String;
	@:optional var exportFolder:String;
	@:optional var clear:Bool;
	@:optional var description:String;
	@:optional var fps:Int; // 60 default
};
