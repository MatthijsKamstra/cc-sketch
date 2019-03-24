package cc.tool;

import js.Browser.document;

class Embed {
	public function new() {
		// your code
	}

	/**
	 * [Description]
	 * @param id
	 * @param src
	 * @param callback
	 * @param callbackArray
	 */
	public static function script(id:String, src:String, ?callback:Dynamic, ?callbackArray:Array<Dynamic>) {
		// trace('${toString()} embedSocketScript');
		var el:js.html.ScriptElement = document.createScriptElement();
		el.id = id;
		el.src = src;
		el.crossOrigin = 'anonymous';
		el.onload = function() {
			// Zip.isZipLoaded = true; // embedding is done
			if (callback != null) {
				if (callbackArray == null) {
					Reflect.callMethod(callback, callback, [id]);
				} else {
					Reflect.callMethod(callback, callback, callbackArray);
				}
			}
		}
		document.body.appendChild(el);
	}
}
