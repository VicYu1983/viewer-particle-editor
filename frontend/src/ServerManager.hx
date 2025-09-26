import haxe.Json;
import js.html.XMLHttpRequest;

class ServerManager {
	private static var instance:ServerManager;

	private function new() {}

	public static function getInstance() {
		if (instance == null) {
			instance = new ServerManager();
		}
		return instance;
	}

	public function list(success:(data:Dynamic) -> Void, failed:() -> Void) {
		var xhr = new XMLHttpRequest();
		xhr.withCredentials = true;
		xhr.addEventListener("readystatechange", function(e) {
			final status = e.currentTarget.status;
			final readyState = e.currentTarget.readyState;

			if (status == 200 && readyState == 4) {
				success(Json.parse(e.currentTarget.responseText));
			}
		});
		xhr.open("GET", "http://localhost:8082/api/particleEffect/list");
		xhr.send();
	}

	public function save(name:String, describtion:String, editorData:String, success:(data:Dynamic) -> Void) {
		var xhr = new XMLHttpRequest();
		xhr.withCredentials = true;

		xhr.addEventListener("readystatechange", function(e) {
			final status = e.currentTarget.status;
			final readyState = e.currentTarget.readyState;

			if (status == 200 && readyState == 4) {
				success(Json.parse(e.currentTarget.responseText));
			}
		});

		xhr.open("POST", "http://localhost:8082/api/particleEffect/save");
		xhr.setRequestHeader("Content-Type", "application/json");

		xhr.send(Json.stringify({name: name, describtion: describtion, json: editorData}));
	}

	public function load(id:Int, success:(data:Dynamic) -> Void) {
		var xhr = new XMLHttpRequest();
		xhr.withCredentials = true;

		xhr.addEventListener("readystatechange", function(e) {
			final status = e.currentTarget.status;
			final readyState = e.currentTarget.readyState;

			if (status == 200 && readyState == 4) {
				success(Json.parse(e.currentTarget.responseText));
			}
		});

		xhr.open("GET", "http://localhost:8082/api/particleEffect/list/" + id);

		xhr.send();
	}

	public function delete(id:Int, success:(data:Dynamic) -> Void) {
		var xhr = new XMLHttpRequest();
		xhr.withCredentials = true;

		xhr.addEventListener("readystatechange", function(e) {
			final status = e.currentTarget.status;
			final readyState = e.currentTarget.readyState;

			if (status == 200 && readyState == 4) {
				success(Json.parse(e.currentTarget.responseText));
			}
		});

		xhr.open("DELETE", "http://localhost:8082/api/particleEffect/list/" + id);

		xhr.send();
	}
}
