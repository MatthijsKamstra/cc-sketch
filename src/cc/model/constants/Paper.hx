package cc.model.constants;

import cc.AST;

/**
A1	594 x 841 mm	23.4 x 33.1 in
A2	420 x 594 mm	16.5 x 23.4 in
A3	297 x 420 mm	11.7 x 16.5 in
A4	210 x 297 mm	8.3 x 11.7 in
A5	148 x 210 mm	5.8 x 8.3 in
A6	105 x 148 mm	4.1 x 5.8 in
**/

class Paper {

	// http://www.papersizes.org/a-paper-sizes.htm

	public static inline var A6 : String = 'a6';
	public static inline var A5 : String = 'a5';
	public static inline var A4 : String = 'a4';
	public static inline var A3 : String = 'a3';
	public static inline var A2 : String = 'a2';
	public static inline var A1 : String = 'a1';


	public static var ARR : Array<String> = [
		A6,
		A5,
		A4,
		A3,
		A2,
		A1
	];

	/**
	 * inPixel
	 *
	 * @example		Paper.inPixel(PaperSize.A$)
	 * @see
	 *
	 * @param
	 *
	 * @return
	 */
	public static function inPixel(papersize:PaperSize):Rectangle{
		var rectangle : Rectangle = {
			width : 0,
			height : 0,
			x : 0,
			y : 0,
		};
		var w : Int;
		var h : Int;
		switch (papersize) {
			case PaperSize.A1:
				w=594; h=841; // mm	23.4 x 33.1 in
			case PaperSize.A2:
				w=420; h=594; // mm	16.5 x 23.4 in
			case PaperSize.A3:
				w=297; h=420; // mm	11.7 x 16.5 in
			case PaperSize.A4:
				w=210; h=297; // mm	8.3 x 11.7 in
			case PaperSize.A5:
				w=148; h=210; // mm	5.8 x 8.3 in
			case PaperSize.A6:
				w=105; h=148; // mm	4.1 x 5.8 in
			default : trace ("case '"+papersize+"': trace ('"+papersize+"');");
		}
		rectangle.width = Std.int(mm2pixel(w));
		rectangle.height = Std.int(mm2pixel(h));
		rectangle.x = 0;
		rectangle.y = 0;
		return rectangle;
	}

	public static function inMM(papersize:String):Rectangle{
		var w : Int = 0;
		var h : Int = 0;
		switch (papersize.toUpperCase()) {
			case 'A1':
				w=594; h=841; // mm	23.4 x 33.1 in
			case 'A2':
				w=420; h=594; // mm	16.5 x 23.4 in
			case 'A3':
				w=297; h=420; // mm	11.7 x 16.5 in
			case 'A4':
				w=210; h=297; // mm	8.3 x 11.7 in
			case 'A5':
				w=148; h=210; // mm	5.8 x 8.3 in
			case 'A6':
				w=105; h=148; // mm	4.1 x 5.8 in
			default : trace ("case '"+papersize+"': trace ('"+papersize+"');");
		}
		var rectangle = {
			width : w,
			height : h,
			x : 0,
			y : 0,
		};
		return rectangle;
	}


	public static function mm2pixel(value:Float):Float{
		var dpi = 72;

		// mm = ( pixels * 25.4 ) / DPI
		// Width : 10 cm * 300 / 2.54 = 1181 pixels
		// Height: 15 cm * 300 / 2.54 = 1772 pixels

		return value * dpi / 25.4;
	}

	/**
	 * [Description]
	 * @param mm
	 * @param dpi
	 * @return Float
	 */
	public static function convertmm2pixel(mm:Float, ?dpi:Int = 72):Float{

		// mm = ( pixels * 25.4 ) / DPI
		// Width : 10 cm * 300 / 2.54 = 1181 pixels
		// Height: 15 cm * 300 / 2.54 = 1772 pixels

		return (mm * dpi / 25.4);
	}

}

typedef Rectangle = {
	@:optional var _id : Int;
	@:optional var x : Int;
	@:optional var y : Int;
	var width : Int;
	var height : Int;
};

enum PaperSize {
	A6;
	A5;
	A4;
	A3;
	A2;
	A1;
}