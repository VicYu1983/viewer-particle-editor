package threejs.particle.system.forces;

import js.Syntax;

@:expose
class WindForce extends BasicForce {
	private final noiseDir:Dynamic;
	private final noisePower:Float;
	private final resolution:Float;

	public function new(force:Float, dir:Dynamic, noisePower:Float = 0, resolution:Float = 1) {
		super(force, dir);

		this.noisePower = noisePower;
		this.resolution = resolution;
		this.noiseDir = Syntax.code('new THREE.Vector3')();
	}

	override function getForce(particle:IParticle):Dynamic {
		final outForce = dir.clone();
		outForce.x = dir.x;
		outForce.y = dir.y;
		outForce.z = dir.z;
		outForce.normalize();
		outForce.multiplyScalar(force);
		if (noisePower > 0) {
			final perlinValue = particle.getPosition().clone().multiplyScalar(resolution);
			final fz = Syntax.code('perlin').get(perlinValue.x, perlinValue.y);
			final fy = Syntax.code('perlin').get(perlinValue.x + .2, perlinValue.z + .4);
			final fx = Syntax.code('perlin').get(perlinValue.y + .6, perlinValue.z + .8);
			noiseDir.x = fx;
			noiseDir.y = fy;
			noiseDir.z = fz;
			noiseDir.normalize();
			noiseDir.multiplyScalar(noisePower);
			outForce.add(noiseDir);
		}
		return outForce;
	}
}
