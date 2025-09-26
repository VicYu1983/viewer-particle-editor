import openfl.events.Event;

class EventWithParams extends Event {
	public final data:Dynamic;

	public function new(type:String, data:Dynamic) {
		super(type, false, false);
		this.data = data;
	}
}
