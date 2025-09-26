package threejs.particle.system.forces;

import js.Syntax;

@:expose
class BasicForce implements IForce {
	public var force:Float = 1;

	public var dir:Dynamic = Syntax.code('new THREE.Vector3(1,0,0)');


	public function new(force:Float, dir:Dynamic) {
		this.force = force;
		this.dir = dir;
		this.dir.normalize();
	}

	public function getForce(particle:IParticle):Dynamic {
		return dir.clone().multiplyScalar(force);
	}
}
