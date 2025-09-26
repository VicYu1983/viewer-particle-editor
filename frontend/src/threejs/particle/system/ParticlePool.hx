package threejs.particle.system;

@:expose
class ParticlePool {
	private final pool:Array<IParticle> = [];

	public function new() {}

	public function request():IParticle {
		if (pool.length > 0) {
			return pool.shift();
		}
		return null;
	}

	public function release(particle:IParticle) {
		pool.push(particle);
	}

	public function getPoolCount() {
		return pool.length;
	}

	// public function clear() {
	// 	while (pool.length > 0) {
	// 		pool.pop();
	// 	}
	// }
}
