package threejs.particle.system;

import js.Syntax;
import openfl.events.EventDispatcher;

@:expose
class ParticleSystem extends EventDispatcher {
	private static var instance:ParticleSystem = null;

	// 發射器
	private final emitters:Array<IParticle> = [];

	// 由發射器產生的粒子。也可以自己加入
	private var particles:Array<IParticle> = [];
	private var id:Int = 0;
	private var viewer:Dynamic;
	private var scene:Dynamic = null;
	private var systemTime:Float = 0;

	// for 3.x
	private var overlayName:String = "";

	private function new() {
		super();
	}

	public static function getInstance() {
		if (instance == null)
			instance = new ParticleSystem();
		return instance;
	}

	public function setViewer(viewer):Void {
		this.viewer = viewer;
	}

	public function setOverlay(name:String) {
		this.overlayName = name;
	}

	public function setScene(scene):Void {
		this.scene = scene;
	}

	public function clearAllEmitter() {
		while (emitters.length > 0) {
			emitters.pop();
		}
	}

	public function clear() {
		for (particle in particles) {
			particle.age = 99999999;
		}
	}

	public function addEmitter(emitter:IParticle) {
		emitters.push(emitter);
		addParticle(emitter.clone());
	}

	public function removeEmitter(emitter:IParticle) {
		emitters.remove(emitter);
	}

	public function play(name:String) {
		final emitter = getEmitter(name);
		if (emitter == null)
			return;
		addParticle(emitter.clone());
	}

	public function playAll() {
		clear();
		for (e in emitters) {
			addParticle(e.clone());
		}
	}

	public function getEmitter(name:String) {
		for (e in emitters) {
			if (e.name == name) {
				return e;
			}
		}
		return null;
	}

	public function getEmitters() {
		return emitters;
	}

	public function addParticle(particle:IParticle) {
		if (particles.indexOf(particle) != -1)
			return;

		// 如果是pool來的粒子，id已經有了
		if (particle.id == null || Syntax.code("typeof particle.id === 'undefined'")) {
			particle.id = id++;
		}

		if (particle.proxy) {
			if (this.overlayName != "") {
				viewer.impl.addOverlay(overlayName, particle.proxy);
			} else {
				getScene().add(particle.proxy);
			}

			// 複製並設置材質球的初始uniform參數
			// 要使用的材質全部都要注冊
			final materialName = "p_" + particle.id;
			if (!getMatman()._materials.hasOwnProperty(materialName)) {
				trace("沒有材質，注冊新材質:" + materialName);

				final cloneMat = particle.proxy.material.clone();
				final uniforms = particle.proxy.material.uniforms;

				getMatman().addMaterial(materialName, cloneMat, true);

				particle.proxy.material = cloneMat;
				if (uniforms != null) {
					// 注冊之後使用才能正常運作

					if (particle.proxy.material.uniforms.colorTex != null) {
						particle.proxy.material.uniforms.colorTex.value = uniforms.colorTex.value;
					}

					if (particle.proxy.material.uniforms.timeOffset != null) {
						particle.proxy.material.uniforms.timeOffset.value = Math.random() * 10;
					}

					if (particle.proxy.material.uniforms.scale != null) {
						particle.proxy.material.uniforms.scale.value.x = 0;
						particle.proxy.material.uniforms.scale.value.y = 0;
					}

					if (particle.proxy.material.uniforms.deadAge != null) {
						particle.proxy.material.uniforms.deadAge.value = particle.deadAge;
					}
				}
			}
		}

		particles.push(particle);

		particle.addEventListener("onParticleDead", function(e:EventWithParams) {
			var p:Dynamic = e.data.particle;

			if (p.pool == null) {
				p.removeEventListener("onParticleDead");
				p.removeEventListener("onParticleSpawn");

				// 不需要的材質反注冊
				clearProxy(p);
				// if (p.proxy != null) {
				// 	if (this.overlayName != "") {
				// 		viewer.impl.removeOverlay(overlayName, p.proxy);
				// 	} else {
				// 		getScene().remove(p.proxy);
				// 	}

				// 	getMatman().removeMaterial("p_" + p.id);
				// }
			}
			particles = particles.filter(function(e) return e != p);
		});

		particle.addEventListener("onParticleSpawn", function(e:EventWithParams) {
			final p = e.data.particle;
			addParticle(p);
		});
	}

	public function getParticleCount() {
		return particles.length;
	}

	public function clearProxy(p:IParticle) {
		if (p.proxy != null) {
			if (this.overlayName != "") {
				viewer.impl.removeOverlay(overlayName, p.proxy);
			} else {
				getScene().remove(p.proxy);
			}

			getMatman().removeMaterial("p_" + p.id);
		}
	}

	public function update(delta:Float) {
		for (id => p in particles) {
			p.update(delta);

			// 更新材質球的uniform參數
			if (p.proxy && p.proxy.material) {
				if (p.proxy.material.uniforms != null) {
					if (p.proxy.material.uniforms.time != null) {
						p.proxy.material.uniforms.time.value = systemTime;
					}

					if (p.proxy.material.uniforms.rotate != null) {
						p.proxy.material.uniforms.rotate.value = p.rotate;
					}

					if (p.proxy.material.uniforms.scale != null) {
						var scale = p.size;

						if (p.sizeIn > 0) {
							final scaleIn = Math.min(p.age / p.sizeIn, 1);
							scale *= scaleIn;
						}

						if (p.sizeOut > 0) {
							var scaleOut = Math.max((p.deadAge - p.age) / p.sizeOut, 0);
							scaleOut = Math.min(Math.max(scaleOut, 0), 1);
							scale *= scaleOut;
						}

						p.proxy.material.uniforms.scale.value.x = scale;
						p.proxy.material.uniforms.scale.value.y = scale;
					}

					if (p.proxy.material.uniforms.age != null) {
						p.proxy.material.uniforms.age.value = p.age;
					}
				}
			}
		}
		systemTime += delta;
	}

	public function convertToJsonObject():Dynamic {
		final obj:Dynamic = {
			emitters: []
		};
		for (e in emitters) {
			obj.emitters.push(e.convertToJsonObject());
		}
		return obj;
	}

	private function getScene():Dynamic {
		if (scene != null)
			return scene;
		return viewer.impl.scene;
	}

	private function getMatman():Dynamic {
		return viewer.impl.matman();
	}
}
