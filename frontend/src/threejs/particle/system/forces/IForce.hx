package threejs.particle.system.forces;

interface IForce {
	var force:Float;
	var dir:Dynamic;
	function getForce(particle:IParticle):Dynamic;
}
