package threejs.particle.geometry;

class GeometryManager {
	private static final instance = new GeometryManager();

    private final map:Map<String, Dynamic> = new Map();

	private function new() {}

	public static function getInstance() {
		return instance;
	}
}
