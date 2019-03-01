package;

import js.Browser.*;
import js.Browser;
import js.html.*;

import cc.model.constants.App;

import art.*;

class Main {

	public function new () {
		trace('START :: main');
		console.log('${App.NAME} Dom ready :: build: ${App.BUILD} ');
		var cc = new CC100();
	}

	static public function main () {
		var app = new Main ();
	}
}