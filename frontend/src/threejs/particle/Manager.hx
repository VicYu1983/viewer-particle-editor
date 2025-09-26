package threejs.particle;

import threejs.particle.system.ParticlePool;
import threejs.particle.system.Emitter;
import threejs.particle.system.IParticle;
import threejs.particle.system.Particle;
import threejs.particle.geometry.GeometryCategory;
import threejs.particle.shader.ShaderCategory;
import threejs.shaders.ShaderTool;
import js.Syntax;
import threejs.shaders.SpriteShader;
import threejs.shaders.ParticleSpriteShader;
import threejs.shaders.BasicShader;
import threejs.particle.system.ParticleSystem;
import threejs.particle.system.forces.IForce;
import threejs.shaders.IShader;

@:expose
class Manager {
	private static var instance = null;

	private final system:ParticleSystem = ParticleSystem.getInstance();

	private final particle:Map<String, IParticle> = new Map();
	private final mesh:Map<String, Dynamic> = new Map();
	private final geometry:Map<String, Dynamic> = new Map();
	private final material:Map<String, Dynamic> = new Map();
	private final shader:Map<String, IShader> = new Map();
	private final texture:Map<String, Dynamic> = new Map();
	private final force:Map<String, IForce> = new Map();

	private var deltaTime = 0;
	private var lastTimestamp = -1;

	private function new() {}

	public static function getInstance() {
		if (instance == null)
			instance = new Manager();
		return instance;
	}

	public function getMesh() {
		return mesh;
	}

	public function getMaterial() {
		return material;
	}

	public function getShader() {
		return shader;
	}

	public function getTexture() {
		return texture;
	}

	public function getForce() {
		return force;
	}

	public function importSystem(data:Dynamic) {
		final _particle:Array<Dynamic> = data.frontend.particle;
		final _mesh:Array<Dynamic> = data.frontend.mesh;
		final _material:Array<Dynamic> = data.frontend.material;
		final _force = data.frontend.force;
		final _enviroment = data.frontend.enviroment;

		for (mat in _material) {
			final uuid = mat.uuid;
			final shaderModel = mat.extra.shader;
			final _material = switch (shaderModel.category) {
				case ShaderCategory.BASIC_SHADER, ShaderCategory.PARTICLE_SPRITE_SHADER, ShaderCategory.SPRITE_SHADER:
					ShaderTool.getMaterial(null, setShaderByCategory(shaderModel.uuid, shaderModel.category), shaderModel.blending, shaderModel.transparent,
						shaderModel.depthWrite, shaderModel.side);
				case ShaderCategory.PHONG_SHADER:
					Syntax.code("new THREE.MeshPhongMaterial")();
				case _:
					null;
			}
			if (_material == null) {
				trace("有沒有實作的shader: " + shaderModel.category);
				continue;
			}

			switch (shaderModel.category) {
				case ShaderCategory.PARTICLE_SPRITE_SHADER:
					_material.uniforms.baseColor.value.x = shaderModel.baseColor[0];
					_material.uniforms.baseColor.value.y = shaderModel.baseColor[1];
					_material.uniforms.baseColor.value.z = shaderModel.baseColor[2];
					_material.uniforms.usingNoise.value = shaderModel.usingNoise;
					_material.uniforms.usingMask.value = shaderModel.usingMask;
					_material.uniforms.usingTex.value = shaderModel.usingTex;
				case ShaderCategory.PHONG_SHADER:
					_material.color = shaderModel.color;
					_material.specular = shaderModel.specular;
					_material.emissive = shaderModel.emissive;
			}

			material.set(uuid, _material);
		}

		for (m in _mesh) {
			final uuid = m.uuid;
			if (m.extra == null) {
				continue;
			}
			final geometryModel = m.extra.geometry;
			final materialModel = m.extra.material;
			final geo = setGeometryByCategory(geometryModel.uuid, geometryModel.category, geometryModel.geo);
			setMeshByCategory(uuid, geo, material.get(materialModel.uuid));
		}

		function syncParticleFromModel(p:IParticle, model:Dynamic) {
			p.acceleration.x = model.acceleration[0];
			p.acceleration.y = model.acceleration[1];
			p.acceleration.z = model.acceleration[2];
			p.velocity.x = model.velocity[0];
			p.velocity.y = model.velocity[1];
			p.velocity.z = model.velocity[2];
			p.age = model.age;
			p.deadAge = model.deadAge;
			p.randomDeadAge = model.randomDeadAge;
			p.rotate = model.rotate;
			p.randomRotate = model.randomRotate;
			p.enabledRotateAlongSpeed = model.enabledRotateAlongSpeed;
			p.mass = model.mass;
			p.size = model.size;
			p.sizeIn = model.sizeIn;
			p.sizeOut = model.sizeOut;
			p.spray.force = model.spray.force;
			p.spray.horizonAngle = model.spray.horizonAngle;
			p.spray.horizonRandom = model.spray.horizonRandom;
			p.spray.verticalAngle = model.spray.verticalAngle;
			p.spray.verticalRandom = model.spray.verticalRandom;
			p.spray.rate = model.spray.rate;
		}

		for (e in _particle) {
			final newEmitter = setParticle(e.uuid, e);
			syncParticleFromModel(newEmitter, e);
			if (e.child != "") {
				final newParticle = setParticle(e.child.uuid, e.child);
				newEmitter.setParticle(newParticle);
				syncParticleFromModel(newParticle, e.child);
				if (e.child.child != "") {
					final newParticle2 = setParticle(e.child.child.uuid, e.child.child);
					newParticle.setParticle(newParticle2);
					syncParticleFromModel(newParticle2, e.child.child);
				}
			}
		}
	}

	public function playEffect(id:String, x:Float = 0, y:Float = 0, z:Float = 0) {
		final emitter = particle.get(id);
		if (emitter == null)
			return;
		emitter.setPosition(x, y, z);
		system.addEmitter(emitter);
	}

	public function setViewer(viewer:Dynamic) {
		system.setViewer(viewer);
	}

	public function update(timestamp) {
		if (lastTimestamp == -1) {
			lastTimestamp = timestamp;
		}
		deltaTime = (timestamp - lastTimestamp);
		lastTimestamp = timestamp;
		system.update(deltaTime * .001);
	}

	private function setParticle(uuid:String, data:Dynamic):IParticle {
		if (particle.exists(uuid))
			return particle.get(uuid);

		final isEmitter = data.child != "";
		final mesh = mesh.get(data.proxy);
		final newParticle = isEmitter ? new Emitter(mesh, new ParticlePool()) : new Particle(mesh, new ParticlePool());
		newParticle.name = data.name;
		particle.set(uuid, newParticle);
		return newParticle;
	}

	private function setMeshByCategory(uuid:String, geo:Dynamic, material:Dynamic):Dynamic {
		if (mesh.exists(uuid))
			return mesh.get(uuid);

		final newMesh:Dynamic = Syntax.code("new THREE.Mesh")(geo, material);

		if (newMesh != null) {
			mesh.set(uuid, newMesh);
		}
		return newMesh;
	}

	private function setGeometryByCategory(uuid:String, category:String, model:Dynamic):Dynamic {
		if (geometry.exists(uuid))
			return geometry.get(uuid);

		final newGeometry:Dynamic = switch (category) {
			case GeometryCategory.CUBE:
				Syntax.code("new THREE.BoxGeometry")(model.width, model.height, model.depth);
			case GeometryCategory.SPHERE:
				Syntax.code("new THREE.SphereGeometry")(model.radius);
			case GeometryCategory.PLANE:
				Syntax.code("new THREE.PlaneBufferGeometry")(model.width, model.height);
			case _:
				null;
		}
		if (newGeometry != null) {
			geometry.set(uuid, newGeometry);
		}
		return newGeometry;
	}

	private function setShaderByCategory(uuid:String, category:String):IShader {
		if (shader.exists(uuid))
			return shader.get(uuid);

		final newShader:IShader = switch (category) {
			case ShaderCategory.BASIC_SHADER:
				new BasicShader();
			case ShaderCategory.PARTICLE_SPRITE_SHADER:
				new ParticleSpriteShader();
			case ShaderCategory.SPRITE_SHADER:
				new SpriteShader();
			case _:
				null;
		}
		if (newShader != null) {
			shader.set(uuid, newShader);
		}
		return newShader;
	}

	// public function exportSystem():Dynamic {
	// 	final data = {
	// 		particle: {
	// 			emitter: system.convertToJsonObject()
	// 		},
	// 		mesh: {},
	// 		material: {},
	// 		force: {},
	// 		enviroment: {}
	// 	};
	// 	return data;
	// }
}
