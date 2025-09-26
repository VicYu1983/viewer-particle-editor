
// import threejs.shaders.particleSystem.ParticleSystemManager;
import threejs.particle.Manager;
import threejs.particle.system.forces.WindForce;
import threejs.particle.system.ParticleSystem;
import threejs.particle.system.Emitter;
import threejs.particle.system.Particle;
import threejs.shaders.ParticleSpriteShader;
import threejs.shaders.ShaderTool;
import threejs.shaders.SpriteShader;
import threejs.shaders.BasicShader;

class MainParticle {
	public static function main() {
		new BasicShader();
		new SpriteShader();
		// new PerlinNoiseMethod();
		new Particle();
		new Emitter();
		ParticleSystem.getInstance();
		// new WindForce()
		new ParticleSpriteShader();
		// new ParticleSystemManager();
		Manager.getInstance();
	}
}
