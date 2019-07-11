package;

import js.Browser.*;

/**

	var setting = new SketchSettings('CC-All-Curved');
	setting.add(this, ['one', 'two', 'three']);

 */
class SketchSettings {
	var localName = '[mck]';
	var localStorage:js.html.Storage;
	var json:SketchSettingsObj;
	var scope:Dynamic;
	var cc:Class<Dynamic>;

	public function new(?name:String) {
		if (name != null)
			this.localName = name; // make sure this is somewhat more clever, based upon url is name is not set
		initData();
	}

	/**
	  [add description]
	  @param scope [description]
	  @param vars  [description]
	**/
	public function add(scope:Dynamic, vars:Dynamic) {
		this.scope = scope;
		trace(Type.typeof(vars));
		// trace(Type.typeof(vars) == Type.ValueType.TFloat);

		if (vars.length != null) {
			// trace(vars.length);
			var arr:Array<Dynamic> = cast(vars);
			setDropdownSketch(arr);
		}

		// if (Type.typeof(vars) == Array) {
		// }
	}

	// ____________________________________ vars ____________________________________

	function setDropdownSketch(arr:Array<Dynamic>) {
		var select = document.createSelectElement();
		select.id = 'xxx';
		select.setAttribute('style', "position:absolute");
		for (i in 0...arr.length) {
			var _a = arr[i];
			select.appendChild(cOption(_a));
		}
		document.body.appendChild(select);

		untyped select.selectedIndex = json.selectedIndex;

		select.onchange = function(e:js.html.Event) {
			console.log(e);
			var select = cast(e.target, js.html.SelectElement);
			json.selectedIndex = select.selectedIndex;
			// console.log(select.value);
			// console.log(select.selectedIndex);
			// localStorage.setItem('selectedIndex', untyped select.selectedIndex);
			// localStorage.setItem('value', select.value);
			// localStorage.setItem('text', select.options[select.selectedIndex].innerText);

			// setSketch();

			setData();
		}
	}

	function cOption(value:String, ?text:String) {
		if (text == null)
			text = value;
		var option = document.createOptionElement();
		option.value = value;
		option.text = text;
		return option;
	}

	// ____________________________________ save localstorage ____________________________________

	function initData() {
		localStorage = js.Browser.getLocalStorage();
		if (localStorage.getItem(this.localName) == null) {
			json = {
				created: Date.now(),
				updated: Date.now(),
				selectedIndex: 0,
				scope: null
			};
			setData();
		} else {
			json = haxe.Json.parse(localStorage.getItem(this.localName));
		}
	}

	function getData() {
		json = haxe.Json.parse(localStorage.getItem(this.localName));
	}

	function setData() {
		Reflect.setField(json, 'updated', Date.now());
		Reflect.setField(json, 'scope', haxe.Json.stringify(this.scope));
		localStorage.setItem(this.localName, haxe.Json.stringify(json));
	}
}

typedef SketchSettingsObj = {
	var updated:Date;
	var created:Date;
	var scope:Dynamic;
	var selectedIndex:Int;
}
