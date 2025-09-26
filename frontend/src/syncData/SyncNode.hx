package syncData;

class SyncNode {
	public var id(default, default):Int;
	public var uuid(default, default):String;
	public var name(default, default):String;
	public var item(default, default):Dynamic;
	public var extra(default, default):Dynamic;

	public function new() {}

	public function getViewNode() {
		final result = {
			id: id,
			name: name,
			text: name,
			item: item
		};
		if (extra != null) {
			var fieldNames:Array<String> = Reflect.fields(extra);
			for (fieldName in fieldNames) {
				var value:Dynamic = Reflect.field(extra, fieldName);
				Reflect.setField(result, fieldName, value);
			}
		}
		return result;
	}
}
