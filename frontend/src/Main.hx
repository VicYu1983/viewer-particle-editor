package;

import js.Syntax;
import haxe.ui.Toolkit;
import haxe.ui.HaxeUIApp;

class Main {
	public static function main() {
		var app = new HaxeUIApp();
		app.ready(function() {
			app.addComponent(new MainView());

			app.start();

			Toolkit.theme = "Dark";
		});
	}

	public static function log(obj:Dynamic) {
		Syntax.code("console.log")(obj);
	}
}
