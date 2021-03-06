package cc.util;

using StringTools;

typedef RGBObject = {
	var r:Int;
	var g:Int;
	var b:Int;
};

typedef RGB = {
	var r:Int;
	var g:Int;
	var b:Int;
};

typedef RGBA = {
	var r:Int;
	var g:Int;
	var b:Int;
	var a:Float;
};

class ColorUtil {
	public function new() {}

	/**
	 * convert an rgb and alpha to RGB or RBGA string value
	 * value checks are done in rgb and rbga function
	 *
	 * @param r		red value (min 0, max 255)
	 * @param g		green value between 0 and 255
	 * @param b		blue value between 0 and 255
	 * @param a 	alpha used for this color (rbga), value is between 0 and 1, if is null rgba is not used
	 * @return String
	 */
	static public function getColour(r:Int, ?g:Int, ?b:Int, ?a:Float):String {
		var c;
		if (g == null) {
			c = rgb(r, r, r);
		} else if (b == null && a == null) {
			c = rgba(r, r, r, g);
		} else if (a == null) {
			c = rgb(r, g, b);
		} else {
			c = rgba(r, g, b, a);
		}
		return (c);
	};

	/**
	 * use the typedef RGB to convert to rgb or rgba string
	 *
	 * @example		cc.util.ColorUtil.getColourObj(BLACK);
	 *
	 * @param rgb 		typedef RGB used, for type checking
	 * @param a 		alpha used for this color (rbga), value is between 0 and 1, if is null rgba is not used
	 * @return String
	 */
	static public function getColourObj(rgb:RGB, ?a:Float):String {
		return getColour(rgb.r, rgb.g, rgb.b, a);
	}

	/**
	 * use RGB values to create color
	 * @param r red (max:255, min:0)
	 * @param g green (max:255, min:0)
	 * @param b blue (max:255, min:0)
	 */
	static public function rgb(r:Int, ?g:Int, ?b:Int):String {
		if (g == null)
			g = r;
		if (b == null)
			b = r;
		return 'rgb(' + MathUtil.clamp(Math.round(r), 0, 255) + ', ' + MathUtil.clamp(Math.round(g), 0, 255) + ', ' + MathUtil.clamp(Math.round(b), 0, 255)
			+ ')';
	};

	static public function rgba(r, ?g, ?b, ?a):String {
		if (g == null) {
			return 'rgb(' + MathUtil.clamp(Math.round(r), 0, 255) + ', ' + MathUtil.clamp(Math.round(r), 0, 255) + ', '
				+ MathUtil.clamp(Math.round(r), 0, 255) + ')';
		} else if (b == null) {
			return 'rgba(' + MathUtil.clamp(Math.round(r), 0, 255) + ', ' + MathUtil.clamp(Math.round(r), 0, 255) + ', '
				+ MathUtil.clamp(Math.round(r), 0, 255) + ', ' + MathUtil.clamp(g, 0, 1) + ')';
		} else if (a == null) {
			return 'rgba(' + MathUtil.clamp(Math.round(r), 0, 255) + ', ' + MathUtil.clamp(Math.round(g), 0, 255) + ', '
				+ MathUtil.clamp(Math.round(b), 0, 255) + ', 1)';
		} else {
			return 'rgba(' + MathUtil.clamp(Math.round(r), 0, 255) + ', ' + MathUtil.clamp(Math.round(g), 0, 255) + ', '
				+ MathUtil.clamp(Math.round(b), 0, 255) + ', ' + MathUtil.clamp(a, 0, 1) + ')';
		}
	};

	/**
	 * [Description]
	 * @param r
	 * @param g
	 * @param b
	 * @return String
	 */
	public static function rgbToHex(r:Int, g:Int, b:Int):String {
		// r = MathUtil.clamp(Math.round(r), 0, 255);
		// g = MathUtil.clamp(Math.round(g), 0, 255);
		// b = MathUtil.clamp(Math.round(b), 0, 255);
		// var hex = StringTools.hex(r,2)
		return StringTools.hex(r, 2) + StringTools.hex(g, 2) + StringTools.hex(b, 2);
	}

	public static function rgb2hex(r:Int, g:Int, b:Int, ?a:Int = 255):Int {
		return (a << 24) | (r << 16) | (g << 8) | b;
	}

	/**
	 * get a random rgb color
	 * @return String
	 */
	static public function randomColour():String {
		var r = MathUtil.randomInt(255);
		var g = MathUtil.randomInt(255);
		var b = MathUtil.randomInt(255);
		return ColorUtil.rgb(r, g, b);
	}

	static public function randomColourObject():RGB {
		var r = MathUtil.randomInt(255);
		var g = MathUtil.randomInt(255);
		var b = MathUtil.randomInt(255);
		return {
			r: r,
			g: g,
			b: b
		};
	}

	// public static function hex2css( color : Int ) : String {
	// 	return "#" + color.toString(16);
	// }

	/**
	 *	@example		var _color = ColorUtil.hex2rgb(0xff3333);
	 *					trace("_color.r: " + _color.r);
	 *
	 */
	// static function hexToRgb(hex:Int):RGBObject {
	// 	var bigint = parseInt(hex, 16);
	// 	var _r = (bigint >> 16) & 255;
	// 	var _g = (bigint >> 8) & 255;
	// 	var _b = bigint & 255;
	// 	return {r:_r, g:_g, b:_b};
	// 	// return r + "," + g + "," + b;
	// }
	// http://old.haxe.org/doc/snip/colorconverter
	public static inline function toRGB(int:Int):RGBObject {
		return {
			r: Math.round(((int >> 16) & 255)),
			g: Math.round(((int >> 8) & 255)),
			b: Math.round((int & 255)),
		}
	}

	public static inline function ttoRGB(int:Int):RGB {
		return {
			r: ((int >> 16) & 255),
			g: ((int >> 8) & 255),
			b: (int & 255),
		}
	}

	/**
	 * all different options that html colors can be converted to.
	 *
	 * this is only tested with
	 * 	- 'rgb(0, 200, 255)'
	 * 	- 'rgba(0, 200, 255, 1)' // but rgba doesntwork
	 *
	 * @param value
	 * @return RGBA
	 */
	public static inline function assumption(value:String):RGBA {
		var _r:Int = 0;
		var _g:Int = 0;
		var _b:Int = 0;
		var _a:Float = 1;
		value = value.replace(' ', ''); // remove spaces

		if (value.indexOf('rgba') != -1) {
			value = value.replace('rgba(', '').replace(')', '');
			var arr = value.split(',');
			_r = cast arr[0];
			_g = cast arr[1];
			_b = cast arr[2];
			_a = cast arr[3];
		} else if (value.indexOf('rgb') != -1) {
			value = value.replace('rgb(', '').replace(')', '');
			var arr = value.split(',');
			_r = cast arr[0];
			_g = cast arr[1];
			_b = cast arr[2];
		} else if (value.indexOf('#') != -1) {
			// value = value.replace('#', '');
			var rgb = hex2RGB(value);
			_r = rgb.r;
			_g = rgb.g;
			_b = rgb.b;
		}
		return {
			r: _r,
			g: _g,
			b: _b,
			a: _a,
		}
	}

	/**
	 * convert a hex value to a RGB type
	 *
	 * @example 	var rgb:RBG = ColorUtil.hex2RGB('#ff3333'); //  {r:255, g:0, b:0};
	 *
	 * @param hex 	string
	 * @return RGB
	 */
	public static inline function hex2RGB(hex:String):RGB {
		var int = Std.parseInt(hex.replace('#', '0x'));
		return {
			r: ((int >> 16) & 255),
			g: ((int >> 8) & 255),
			b: (int & 255),
		}
	}

	// public static var BLACK : RGBObject = {r:0, g:0, b:0};
	// public static var WHITE : RGBObject = {r:255, g:255, b:255};
	// public static var RED : RGBObject = {r:255, g:0, b:0};
	// https://clrs.cc/
	public static var NAVY:RGBObject = toRGB(0x001f3f);
	public static var BLUE:RGBObject = toRGB(0x0074D9);
	public static var AQUA:RGBObject = toRGB(0x7FDBFF);
	public static var TEAL:RGBObject = toRGB(0x39CCCC);
	public static var OLIVE:RGBObject = toRGB(0x3D9970);
	public static var GREEN:RGBObject = toRGB(0x2ECC40);
	public static var LIME:RGBObject = toRGB(0x01FF70);
	public static var YELLOW:RGBObject = toRGB(0xFFDC00);
	public static var ORANGE:RGBObject = toRGB(0xFF851B);
	public static var RED:RGBObject = toRGB(0xFF4136);
	public static var MAROON:RGBObject = toRGB(0x85144b);
	public static var FUCHSIA:RGBObject = toRGB(0xF012BE);
	public static var PURPLE:RGBObject = toRGB(0xB10DC9);
	public static var BLACK:RGBObject = toRGB(0x111111);
	public static var GRAY:RGBObject = toRGB(0xAAAAAA);
	public static var SILVER:RGBObject = toRGB(0xDDDDDD);
	public static var WHITE:RGBObject = toRGB(0xFFFFFF);
	// [mck] my favourite debug color
	public static var PINK:RGBObject = toRGB(0xFF1493); // deeppink
	public static var PINK_DEEP:RGBObject = toRGB(0xFF1493); // deeppink
	public static var PINK_HOT:RGBObject = toRGB(0xff69B4); // hotpink
	// 500 and 1000 are to big for most ide... but do you really need that much color combinations?
	public static var niceColor100:Array<Array<String>> = [
		["#69d2e7", "#a7dbd8", "#e0e4cc", "#f38630", "#fa6900"], ["#fe4365", "#fc9d9a", "#f9cdad", "#c8c8a9", "#83af9b"],
		["#ecd078", "#d95b43", "#c02942", "#542437", "#53777a"], ["#556270", "#4ecdc4", "#c7f464", "#ff6b6b", "#c44d58"],
		["#774f38", "#e08e79", "#f1d4af", "#ece5ce", "#c5e0dc"], ["#e8ddcb", "#cdb380", "#036564", "#033649", "#031634"],
		["#490a3d", "#bd1550", "#e97f02", "#f8ca00", "#8a9b0f"], ["#594f4f", "#547980", "#45ada8", "#9de0ad", "#e5fcc2"],
		["#00a0b0", "#6a4a3c", "#cc333f", "#eb6841", "#edc951"], ["#e94e77", "#d68189", "#c6a49a", "#c6e5d9", "#f4ead5"],
		["#3fb8af", "#7fc7af", "#dad8a7", "#ff9e9d", "#ff3d7f"], ["#d9ceb2", "#948c75", "#d5ded9", "#7a6a53", "#99b2b7"],
		["#ffffff", "#cbe86b", "#f2e9e1", "#1c140d", "#cbe86b"], ["#efffcd", "#dce9be", "#555152", "#2e2633", "#99173c"],
		["#343838", "#005f6b", "#008c9e", "#00b4cc", "#00dffc"], ["#413e4a", "#73626e", "#b38184", "#f0b49e", "#f7e4be"],
		["#ff4e50", "#fc913a", "#f9d423", "#ede574", "#e1f5c4"], ["#99b898", "#fecea8", "#ff847c", "#e84a5f", "#2a363b"],
		["#655643", "#80bca3", "#f6f7bd", "#e6ac27", "#bf4d28"], ["#00a8c6", "#40c0cb", "#f9f2e7", "#aee239", "#8fbe00"],
		["#351330", "#424254", "#64908a", "#e8caa4", "#cc2a41"], ["#554236", "#f77825", "#d3ce3d", "#f1efa5", "#60b99a"],
		["#ff9900", "#424242", "#e9e9e9", "#bcbcbc", "#3299bb"], ["#5d4157", "#838689", "#a8caba", "#cad7b2", "#ebe3aa"],
		["#8c2318", "#5e8c6a", "#88a65e", "#bfb35a", "#f2c45a"], ["#fad089", "#ff9c5b", "#f5634a", "#ed303c", "#3b8183"],
		["#ff4242", "#f4fad2", "#d4ee5e", "#e1edb9", "#f0f2eb"], ["#d1e751", "#ffffff", "#000000", "#4dbce9", "#26ade4"],
		["#f8b195", "#f67280", "#c06c84", "#6c5b7b", "#355c7d"], ["#1b676b", "#519548", "#88c425", "#bef202", "#eafde6"],
		["#bcbdac", "#cfbe27", "#f27435", "#f02475", "#3b2d38"], ["#5e412f", "#fcebb6", "#78c0a8", "#f07818", "#f0a830"],
		["#452632", "#91204d", "#e4844a", "#e8bf56", "#e2f7ce"], ["#eee6ab", "#c5bc8e", "#696758", "#45484b", "#36393b"],
		["#f0d8a8", "#3d1c00", "#86b8b1", "#f2d694", "#fa2a00"], ["#f04155", "#ff823a", "#f2f26f", "#fff7bd", "#95cfb7"],
		["#2a044a", "#0b2e59", "#0d6759", "#7ab317", "#a0c55f"], ["#bbbb88", "#ccc68d", "#eedd99", "#eec290", "#eeaa88"],
		["#b9d7d9", "#668284", "#2a2829", "#493736", "#7b3b3b"], ["#b3cc57", "#ecf081", "#ffbe40", "#ef746f", "#ab3e5b"],
		["#a3a948", "#edb92e", "#f85931", "#ce1836", "#009989"], ["#67917a", "#170409", "#b8af03", "#ccbf82", "#e33258"],
		["#e8d5b7", "#0e2430", "#fc3a51", "#f5b349", "#e8d5b9"], ["#aab3ab", "#c4cbb7", "#ebefc9", "#eee0b7", "#e8caaf"],
		["#300030", "#480048", "#601848", "#c04848", "#f07241"], ["#ab526b", "#bca297", "#c5ceae", "#f0e2a4", "#f4ebc3"],
		["#607848", "#789048", "#c0d860", "#f0f0d8", "#604848"], ["#a8e6ce", "#dcedc2", "#ffd3b5", "#ffaaa6", "#ff8c94"],
		["#3e4147", "#fffedf", "#dfba69", "#5a2e2e", "#2a2c31"], ["#b6d8c0", "#c8d9bf", "#dadabd", "#ecdbbc", "#fedcba"],
		["#fc354c", "#29221f", "#13747d", "#0abfbc", "#fcf7c5"], ["#1c2130", "#028f76", "#b3e099", "#ffeaad", "#d14334"],
		["#edebe6", "#d6e1c7", "#94c7b6", "#403b33", "#d3643b"], ["#cc0c39", "#e6781e", "#c8cf02", "#f8fcc1", "#1693a7"],
		["#dad6ca", "#1bb0ce", "#4f8699", "#6a5e72", "#563444"], ["#a7c5bd", "#e5ddcb", "#eb7b59", "#cf4647", "#524656"],
		["#fdf1cc", "#c6d6b8", "#987f69", "#e3ad40", "#fcd036"], ["#5c323e", "#a82743", "#e15e32", "#c0d23e", "#e5f04c"],
		["#230f2b", "#f21d41", "#ebebbc", "#bce3c5", "#82b3ae"], ["#b9d3b0", "#81bda4", "#b28774", "#f88f79", "#f6aa93"],
		["#3a111c", "#574951", "#83988e", "#bcdea5", "#e6f9bc"], ["#5e3929", "#cd8c52", "#b7d1a3", "#dee8be", "#fcf7d3"],
		["#1c0113", "#6b0103", "#a30006", "#c21a01", "#f03c02"], ["#382f32", "#ffeaf2", "#fcd9e5", "#fbc5d8", "#f1396d"],
		["#e3dfba", "#c8d6bf", "#93ccc6", "#6cbdb5", "#1a1f1e"], ["#000000", "#9f111b", "#b11623", "#292c37", "#cccccc"],
		["#c1b398", "#605951", "#fbeec2", "#61a6ab", "#accec0"], ["#8dccad", "#988864", "#fea6a2", "#f9d6ac", "#ffe9af"],
		["#f6f6f6", "#e8e8e8", "#333333", "#990100", "#b90504"], ["#1b325f", "#9cc4e4", "#e9f2f9", "#3a89c9", "#f26c4f"],
		["#5e9fa3", "#dcd1b4", "#fab87f", "#f87e7b", "#b05574"], ["#951f2b", "#f5f4d7", "#e0dfb1", "#a5a36c", "#535233"],
		["#413d3d", "#040004", "#c8ff00", "#fa023c", "#4b000f"], ["#eff3cd", "#b2d5ba", "#61ada0", "#248f8d", "#605063"],
		["#2d2d29", "#215a6d", "#3ca2a2", "#92c7a3", "#dfece6"], ["#cfffdd", "#b4dec1", "#5c5863", "#a85163", "#ff1f4c"],
		["#4e395d", "#827085", "#8ebe94", "#ccfc8e", "#dc5b3e"], ["#9dc9ac", "#fffec7", "#f56218", "#ff9d2e", "#919167"],
		["#a1dbb2", "#fee5ad", "#faca66", "#f7a541", "#f45d4c"], ["#ffefd3", "#fffee4", "#d0ecea", "#9fd6d2", "#8b7a5e"],
		["#a8a7a7", "#cc527a", "#e8175d", "#474747", "#363636"], ["#ffedbf", "#f7803c", "#f54828", "#2e0d23", "#f8e4c1"],
		["#f8edd1", "#d88a8a", "#474843", "#9d9d93", "#c5cfc6"], ["#f38a8a", "#55443d", "#a0cab5", "#cde9ca", "#f1edd0"],
		["#4e4d4a", "#353432", "#94ba65", "#2790b0", "#2b4e72"], ["#0ca5b0", "#4e3f30", "#fefeeb", "#f8f4e4", "#a5b3aa"],
		["#a70267", "#f10c49", "#fb6b41", "#f6d86b", "#339194"], ["#9d7e79", "#ccac95", "#9a947c", "#748b83", "#5b756c"],
		["#edf6ee", "#d1c089", "#b3204d", "#412e28", "#151101"], ["#046d8b", "#309292", "#2fb8ac", "#93a42a", "#ecbe13"],
		["#4d3b3b", "#de6262", "#ffb88c", "#ffd0b3", "#f5e0d3"], ["#fffbb7", "#a6f6af", "#66b6ab", "#5b7c8d", "#4f2958"],
		["#ff003c", "#ff8a00", "#fabe28", "#88c100", "#00c176"], ["#fcfef5", "#e9ffe1", "#cdcfb7", "#d6e6c3", "#fafbe3"],
		["#9cddc8", "#bfd8ad", "#ddd9ab", "#f7af63", "#633d2e"], ["#30261c", "#403831", "#36544f", "#1f5f61", "#0b8185"],
		["#d1313d", "#e5625c", "#f9bf76", "#8eb2c5", "#615375"], ["#ffe181", "#eee9e5", "#fad3b2", "#ffba7f", "#ff9c97"],
		["#aaff00", "#ffaa00", "#ff00aa", "#aa00ff", "#00aaff"], ["#c2412d", "#d1aa34", "#a7a844", "#a46583", "#5a1e4a"]
	];
	public static var niceColor100SortedString:Array<Array<String>> = [
		["#E0E4CC", "#A7DBD8", "#69D2E7", "#F38630", "#FA6900"], ["#F9CDAD", "#C8C8A9", "#FC9D9A", "#83AF9B", "#FE4365"],
		["#ECD078", "#D95B43", "#53777A", "#C02942", "#542437"], ["#C7F464", "#4ECDC4", "#FF6B6B", "#C44D58", "#556270"],
		["#ECE5CE", "#F1D4AF", "#C5E0DC", "#E08E79", "#774F38"], ["#E8DDCB", "#CDB380", "#036564", "#033649", "#031634"],
		["#F8CA00", "#E97F02", "#8A9B0F", "#BD1550", "#490A3D"], ["#E5FCC2", "#9DE0AD", "#45ADA8", "#547980", "#594F4F"],
		["#EDC951", "#EB6841", "#00A0B0", "#CC333F", "#6A4A3C"], ["#F4EAD5", "#C6E5D9", "#C6A49A", "#D68189", "#E94E77"],
		["#DAD8A7", "#FF9E9D", "#7FC7AF", "#3FB8AF", "#FF3D7F"], ["#D5DED9", "#D9CEB2", "#99B2B7", "#948C75", "#7A6A53"],
		["#FFFFFF", "#F2E9E1", "#CBE86B", "#CBE86B", "#1C140D"], ["#EFFFCD", "#DCE9BE", "#555152", "#99173C", "#2E2633"],
		["#00DFFC", "#00B4CC", "#008C9E", "#005F6B", "#343838"], ["#F7E4BE", "#F0B49E", "#B38184", "#73626E", "#413E4A"],
		["#E1F5C4", "#EDE574", "#F9D423", "#FC913A", "#FF4E50"], ["#FECEA8", "#99B898", "#FF847C", "#E84A5F", "#2A363B"],
		["#F6F7BD", "#E6AC27", "#80BCA3", "#BF4D28", "#655643"], ["#F9F2E7", "#AEE239", "#40C0CB", "#8FBE00", "#00A8C6"],
		["#E8CAA4", "#64908A", "#CC2A41", "#424254", "#351330"], ["#F1EFA5", "#D3CE3D", "#60B99A", "#F77825", "#554236"],
		["#E9E9E9", "#BCBCBC", "#FF9900", "#3299BB", "#424242"], ["#EBE3AA", "#CAD7B2", "#A8CABA", "#838689", "#5D4157"],
		["#F2C45A", "#BFB35A", "#88A65E", "#5E8C6A", "#8C2318"], ["#FAD089", "#FF9C5B", "#F5634A", "#3B8183", "#ED303C"],
		["#F4FAD2", "#F0F2EB", "#E1EDB9", "#D4EE5E", "#FF4242"], ["#FFFFFF", "#D1E751", "#4DBCE9", "#26ADE4", "#000000"],
		["#F8B195", "#F67280", "#C06C84", "#6C5B7B", "#355C7D"], ["#EAFDE6", "#BEF202", "#88C425", "#519548", "#1B676B"],
		["#BCBDAC", "#CFBE27", "#F27435", "#F02475", "#3B2D38"], ["#FCEBB6", "#F0A830", "#78C0A8", "#F07818", "#5E412F"],
		["#E2F7CE", "#E8BF56", "#E4844A", "#91204D", "#452632"], ["#EEE6AB", "#C5BC8E", "#696758", "#45484B", "#36393B"],
		["#F0D8A8", "#F2D694", "#86B8B1", "#FA2A00", "#3D1C00"], ["#FFF7BD", "#F2F26F", "#95CFB7", "#FF823A", "#F04155"],
		["#A0C55F", "#7AB317", "#0D6759", "#0B2E59", "#2A044A"], ["#EEDD99", "#EEC290", "#CCC68D", "#EEAA88", "#BBBB88"],
		["#B9D7D9", "#668284", "#7B3B3B", "#493736", "#2A2829"], ["#ECF081", "#FFBE40", "#B3CC57", "#EF746F", "#AB3E5B"],
		["#EDB92E", "#A3A948", "#F85931", "#009989", "#CE1836"], ["#CCBF82", "#B8AF03", "#67917A", "#E33258", "#170409"],
		["#E8D5B9", "#E8D5B7", "#F5B349", "#FC3A51", "#0E2430"], ["#EBEFC9", "#EEE0B7", "#E8CAAF", "#C4CBB7", "#AAB3AB"],
		["#F07241", "#C04848", "#601848", "#480048", "#300030"], ["#F4EBC3", "#F0E2A4", "#C5CEAE", "#BCA297", "#AB526B"],
		["#F0F0D8", "#C0D860", "#789048", "#607848", "#604848"], ["#DCEDC2", "#FFD3B5", "#A8E6CE", "#FFAAA6", "#FF8C94"],
		["#FFFEDF", "#DFBA69", "#3E4147", "#5A2E2E", "#2A2C31"], ["#FEDCBA", "#ECDBBC", "#DADABD", "#C8D9BF", "#B6D8C0"],
		["#FCF7C5", "#0ABFBC", "#FC354C", "#13747D", "#29221F"], ["#FFEAAD", "#B3E099", "#D14334", "#028F76", "#1C2130"],
		["#EDEBE6", "#D6E1C7", "#94C7B6", "#D3643B", "#403B33"], ["#F8FCC1", "#C8CF02", "#E6781E", "#1693A7", "#CC0C39"],
		["#DAD6CA", "#1BB0CE", "#4F8699", "#6A5E72", "#563444"], ["#E5DDCB", "#A7C5BD", "#EB7B59", "#CF4647", "#524656"],
		["#FDF1CC", "#C6D6B8", "#FCD036", "#E3AD40", "#987F69"], ["#E5F04C", "#C0D23E", "#E15E32", "#A82743", "#5C323E"],
		["#EBEBBC", "#BCE3C5", "#82B3AE", "#F21D41", "#230F2B"], ["#B9D3B0", "#F6AA93", "#F88F79", "#81BDA4", "#B28774"],
		["#E6F9BC", "#BCDEA5", "#83988E", "#574951", "#3A111C"], ["#FCF7D3", "#DEE8BE", "#B7D1A3", "#CD8C52", "#5E3929"],
		["#F03C02", "#C21A01", "#A30006", "#6B0103", "#1C0113"], ["#FFEAF2", "#FCD9E5", "#FBC5D8", "#F1396D", "#382F32"],
		["#E3DFBA", "#C8D6BF", "#93CCC6", "#6CBDB5", "#1A1F1E"], ["#CCCCCC", "#B11623", "#9F111B", "#292C37", "#000000"],
		["#FBEEC2", "#ACCEC0", "#C1B398", "#61A6AB", "#605951"], ["#FFE9AF", "#F9D6AC", "#FEA6A2", "#8DCCAD", "#988864"],
		["#F6F6F6", "#E8E8E8", "#B90504", "#333333", "#990100"], ["#E9F2F9", "#9CC4E4", "#F26C4F", "#3A89C9", "#1B325F"],
		["#DCD1B4", "#FAB87F", "#F87E7B", "#5E9FA3", "#B05574"], ["#F5F4D7", "#E0DFB1", "#A5A36C", "#535233", "#951F2B"],
		["#C8FF00", "#FA023C", "#413D3D", "#4B000F", "#040004"], ["#EFF3CD", "#B2D5BA", "#61ADA0", "#248F8D", "#605063"],
		["#DFECE6", "#92C7A3", "#3CA2A2", "#215A6D", "#2D2D29"], ["#CFFFDD", "#B4DEC1", "#A85163", "#FF1F4C", "#5C5863"],
		["#CCFC8E", "#8EBE94", "#DC5B3E", "#827085", "#4E395D"], ["#FFFEC7", "#9DC9AC", "#FF9D2E", "#919167", "#F56218"],
		["#FEE5AD", "#FACA66", "#A1DBB2", "#F7A541", "#F45D4C"], ["#FFFEE4", "#FFEFD3", "#D0ECEA", "#9FD6D2", "#8B7A5E"],
		["#A8A7A7", "#CC527A", "#E8175D", "#474747", "#363636"], ["#FFEDBF", "#F8E4C1", "#F7803C", "#F54828", "#2E0D23"],
		["#F8EDD1", "#C5CFC6", "#D88A8A", "#9D9D93", "#474843"], ["#F1EDD0", "#CDE9CA", "#A0CAB5", "#F38A8A", "#55443D"],
		["#94BA65", "#2790B0", "#4E4D4A", "#2B4E72", "#353432"], ["#FEFEEB", "#F8F4E4", "#A5B3AA", "#0CA5B0", "#4E3F30"],
		["#F6D86B", "#FB6B41", "#339194", "#F10C49", "#A70267"], ["#CCAC95", "#9A947C", "#9D7E79", "#748B83", "#5B756C"],
		["#EDF6EE", "#D1C089", "#B3204D", "#412E28", "#151101"], ["#ECBE13", "#93A42A", "#2FB8AC", "#309292", "#046D8B"],
		["#F5E0D3", "#FFD0B3", "#FFB88C", "#DE6262", "#4D3B3B"], ["#FFFBB7", "#A6F6AF", "#66B6AB", "#5B7C8D", "#4F2958"],
		["#FABE28", "#FF8A00", "#88C100", "#00C176", "#FF003C"], ["#FCFEF5", "#FAFBE3", "#E9FFE1", "#D6E6C3", "#CDCFB7"],
		["#DDD9AB", "#BFD8AD", "#9CDDC8", "#F7AF63", "#633D2E"], ["#0B8185", "#1F5F61", "#36544F", "#403831", "#30261C"],
		["#F9BF76", "#8EB2C5", "#E5625C", "#D1313D", "#615375"], ["#EEE9E5", "#FFE181", "#FAD3B2", "#FFBA7F", "#FF9C97"],
		["#AAFF00", "#FFAA00", "#00AAFF", "#FF00AA", "#AA00FF"], ["#D1AA34", "#A7A844", "#A46583", "#C2412D", "#5A1E4A"],
		["#F8F3BF", "#DCE4F7", "#BFCFF7", "#75616B", "#D34017"]];

	/**
	 * 		var colorArray = ColorUtil.niceColor100SortedInt[randomInt(ColorUtil.niceColor100SortedInt.length - 1)];
	 */
	public static var niceColor100SortedInt:Array<Array<Int>> = [
		[14738636, 11000792, 6935271, 15959600, 16410880], [16371117, 13158569, 16555418, 8630171, 16663397],
		[15519864, 14244675, 5470074, 12593474, 5514295], [13104228, 5164484, 16739179, 12864856, 5595760], [15525326, 15848623, 12968156, 14716537, 7819064],
		[15261131, 13480832, 222564, 210505, 202292], [16304640, 15302402, 9083663, 12391760, 4786749], [15072450, 10346669, 4566440, 5536128, 5853007],
		[15583569, 15427649, 41136, 13382463, 6965820], [16050901, 13034969, 13018266, 14057865, 15289975], [14342311, 16752285, 8374191, 4176047, 16727423],
		[14016217, 14274226, 10072759, 9735285, 8022611], [16777215, 15919585, 13363307, 13363307, 1840141], [15728589, 14477758, 5591378, 10032956, 3024435],
		[57340, 46284, 35998, 24427, 3422264], [16245950, 15774878, 11764100, 7561838, 4275786], [14808516, 15590772, 16372771, 16552250, 16731728],
		[16699048, 10074264, 16745596, 15223391, 2766395], [16185277, 15117351, 8436899, 12537128, 6641219], [16380647, 11461177, 4243659, 9420288, 43206],
		[15256228, 6590602, 13380161, 4342356, 3478320], [15855525, 13880893, 6338970, 16218149, 5587510], [15329769, 12369084, 16750848, 3316155, 4342338],
		[15459242, 13293490, 11061946, 8619657, 6111575], [15909978, 12563290, 8955486, 6196330, 9184024], [16437385, 16751707, 16081738, 3899779, 15544380],
		[16054994, 15790827, 14806457, 13954654, 16728642], [16777215, 13756241, 5094633, 2534884, 0], [16298389, 16151168, 12610692, 7101307, 3497085],
		[15400422, 12513794, 8963109, 5346632, 1795947], [12369324, 13614631, 15889461, 15737973, 3878200], [16575414, 15771696, 7913640, 15759384, 6177071],
		[14874574, 15253334, 14976074, 9510989, 4531762], [15656619, 12958862, 6907736, 4540491, 3553595], [15784104, 15914644, 8829105, 16394752, 4004864],
		[16775101, 15921775, 9818039, 16745018, 15745365], [10536287, 8041239, 878425, 732761, 2753610], [15654297, 15647376, 13420173, 15641224, 12303240],
		[12179417, 6718084, 8076091, 4798262, 2762793], [15528065, 16760384, 11783255, 15692911, 11222619], [15579438, 10725704, 16275761, 39305, 13506614],
		[13418370, 12103427, 6787450, 14889560, 1508361], [15259065, 15259063, 16102217, 16530001, 926768],
		[15462345, 15655095, 15256239, 12897207, 11187115], [15757889, 12601416, 6297672, 4718664, 3145776],
		[16051139, 15786660, 12963502, 12362391, 11227755], [15790296, 12638304, 7901256, 6322248, 6309960],
		[14478786, 16765877, 11069134, 16755366, 16747668], [16776927, 14662249, 4079943, 5910062, 2763825],
		[16702650, 15522748, 14342845, 13162943, 11983040], [16578501, 704444, 16528716, 1275005, 2695711], [16771757, 11788441, 13714228, 167798, 1843504],
		[15592422, 14082503, 9750454, 13853755, 4209459], [16317633, 13160194, 15104030, 1479591, 13372473], [14341834, 1814734, 5211801, 6970994, 5649476],
		[15064523, 10995133, 15432537, 13583943, 5391958], [16642508, 13031096, 16568374, 14921024, 9994089],
		[15069260, 12636734, 14769714, 11020099, 6042174], [15461308, 12379077, 8565678, 15867201, 2297643],
		[12178352, 16165523, 16289657, 8502692, 11700084], [15137212, 12377765, 8624270, 5720401, 3805468], [16578515, 14608574, 12046755, 13470802, 6175017],
		[15744002, 12720641, 10682374, 7012611, 1835283], [16771826, 16570853, 16500184, 15808877, 3682098], [14933946, 13162175, 9686214, 7126453, 1711902],
		[13421772, 11605539, 10424603, 2698295, 0], [16510658, 11325120, 12694424, 6399659, 6314321], [16771503, 16373420, 16688802, 9292973, 9996388],
		[16185078, 15263976, 12125444, 3355443, 10027264], [15332089, 10274020, 15887439, 3836361, 1782367],
		[14471604, 16431231, 16285307, 6201251, 11556212], [16118999, 14737329, 10855276, 5460531, 9772843], [13172480, 16384572, 4275517, 4915215, 262148],
		[15725517, 11720122, 6401440, 2396045, 6312035], [14675174, 9619363, 3973794, 2185837, 2960681], [13631453, 11853505, 11030883, 16719692, 6051939],
		[13433998, 9354900, 14441278, 8548485, 5126493], [16776903, 10340780, 16751918, 9539943, 16081432],
		[16704941, 16435814, 10607538, 16229697, 16014668], [16776932, 16773075, 13692138, 10475218, 9140830],
		[11052967, 13390458, 15210333, 4671303, 3552822], [16772543, 16311489, 16220220, 16074792, 3018019],
		[16313809, 12963782, 14191242, 10329491, 4671555], [15855056, 13494730, 10537653, 15960714, 5588029], [9747045, 2592944, 5131594, 2838130, 3486770],
		[16711403, 16315620, 10859434, 828848, 5127984], [16177259, 16476993, 3379604, 15797321, 10945127], [13413525, 10130556, 10321529, 7637891, 5993836],
		[15595246, 13746313, 11739213, 4271656, 1380609], [15515155, 9675818, 3127468, 3183250, 290187], [16113875, 16765107, 16758924, 14574178, 5061435],
		[16776119, 10942127, 6731435, 5995661, 5187928], [16432680, 16747008, 8962304, 49526, 16711740], [16580341, 16448483, 15335393, 14083779, 13488055],
		[14539179, 12572845, 10280392, 16232291, 6503726], [754053, 2056033, 3560527, 4208689, 3155484], [16367478, 9351877, 15032924, 13709629, 6378357],
		[15657445, 16769409, 16438194, 16759423, 16751767], [11206400, 16755200, 43775, 16711850, 11141375],
		[13740596, 10987588, 10773891, 12730669, 5905994], [16315327, 14476535, 12570615, 7692651, 13844503]];
}
