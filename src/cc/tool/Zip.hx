package cc.tool;

import js.Browser.*;
import cc.tool.Embed;

/**
 * externs
 * https://github.com/abedev/npm/blob/master/src/npm/JSZip.hx
 */
class Zip {
	// public var _isEmbedded:Bool = false;
	public static var isZipLoaded:Bool = false;
	public static var isFileLoaded:Bool = false;

	public function new() {
		// your code
	}

	// ____________________________________ inject script into page ____________________________________

	public function embedScripts(?callback:Dynamic, ?callbackArray:Array<Dynamic>) {
		Embed.script('jszip', 'https://cdnjs.cloudflare.com/ajax/libs/jszip/3.2.0/jszip.min.js', callback);
		Embed.script('jsfilesaver', 'https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js', callback);
	}
}
