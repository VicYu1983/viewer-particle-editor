package threejs.particle.system;

import threejs.particle.system.forces.IForce;
import threejs.particle.system.IParticle.Spray;
import js.Syntax;
import openfl.events.EventDispatcher;

@:expose
class Particle implements IParticle extends EventDispatcher {
	public var uuid:String = "";
	public var name:String = "";
	public var pool:ParticlePool;
	public var parent:IParticle = null;
	public var child:IParticle = null;
	public var spray:Spray = {
		horizonAngle: 0,
		horizonRandom: 0,
		verticalAngle: 0,
		verticalRandom: 0,
		force: 1,
		rate: 1
	};
	public var id:Int = null;
	public var age:Float = 0;
	public var deadAge:Float = 5;
	public var randomDeadAge:Float = 0;
	public var proxy:Dynamic;
	public var forces:Array<IForce> = [];
	public var acceleration:Dynamic = Syntax.code('new THREE.Vector3')();
	public var velocity:Dynamic = Syntax.code('new THREE.Vector3')();
	public var mass:Float = 1.0;
	public var rotate:Float = 0;
	public var rotateSpeed:Float = 0;
	public var randomRotate:Float = 0;
	public var randomPosition:Dynamic = Syntax.code('new THREE.Vector3')();
	public var size:Float = 1;
	public var randomSize:Float = 0;
	public var sizeIn:Float = 0;
	public var sizeOut:Float = 0;
	public var enabledRotateAlongSpeed:Bool = false;

	private var position:Dynamic = Syntax.code('new THREE.Vector3')();
	private var rotate3d:Dynamic = Syntax.code('new THREE.Vector3')();
	private var scale3d:Dynamic = Syntax.code('new THREE.Vector3')(1, 1, 1);

	public function new(proxy:Dynamic = null, pool:ParticlePool = null) {
		super();

		// trace('proxy:');
		// trace( proxy );
		this.proxy = proxy;
		this.pool = pool;
	}

	public function setParticle(particle:IParticle):Void {
		// particle should not set particle
		trace("particle should not set particle");
	}

	// public function clearPool():Void {
	// 	if (pool != null) {
	// 		pool.clear();
	// 	}
	// }

	private function syncPosition():Void {
		if (proxy) {
			proxy.position.x = position.x;
			proxy.position.y = position.y;
			proxy.position.z = position.z;
		}
	}

	private function syncRotation():Void {
		if (proxy) {
			proxy.rotation.x = rotate3d.x;
			proxy.rotation.y = rotate3d.y;
			proxy.rotation.z = rotate3d.z;
		}
	}

	private function syncScale():Void {
		if (proxy) {
			proxy.scale.x = scale3d.x;
			proxy.scale.y = scale3d.y;
			proxy.scale.z = scale3d.z;
		}
	}

	public function getPosition() {
		return position;
	}

	public function getRotation() {
		return rotate3d;
	}

	public function getScale() {
		return scale3d;
	}

	public function setPosition(x:Float, y:Float, z:Float):Void {
		position.x = x;
		position.y = y;
		position.z = z;

		syncPosition();
	}

	public function setRotation(x:Float, y:Float, z:Float):Void {
		rotate3d.x = x;
		rotate3d.y = y;
		rotate3d.z = z;

		syncRotation();
	}

	public function setScale(x:Float, y:Float, z:Float):Void {
		scale3d.x = x;
		scale3d.y = y;
		scale3d.z = z;
		syncScale();
	}

	public function addForce(force:Dynamic):Void {
		forces.push(force);
	}

	public function applyForce(force:Dynamic):Void {
		acceleration.add(force.divideScalar(this.mass));
	}

	public function update(delta:Float):Void {
		age += delta;

		if (age >= deadAge) {
			if (pool != null) {
				if (proxy != null) {
					setScale(0, 0, 0);
					size = 0;
				}
				pool.release(this);
			}
			dispatchEvent(new EventWithParams('onParticleDead', {particle: this}));
		}

		for (index => value in forces) {
			applyForce(value.getForce(this));
		}

		velocity.add(acceleration.multiplyScalar(delta));
		position.add(velocity);
		rotate += rotateSpeed;

		if (enabledRotateAlongSpeed) {
			// 首先，创建一个单位向量作为参考方向（例如，正 x 方向）
			final referenceDirection = Syntax.code('new THREE.Vector3')(1, 0, 0);

			// 根据参考方向和 velocity 的夹角来确定一个新的参考方向
			final angle = velocity.angleTo(referenceDirection);
			final epsilon = 1e-5; // 一个小的阈值，用于检查是否共线
			var referenceDirectionNew;

			if (angle < epsilon) {
				// velocity 与参考方向共线，需要选择一个不共线的参考方向
				referenceDirectionNew = Syntax.code('new THREE.Vector3')(0, 1, 0); // 选择正 y 方向
			} else {
				// velocity 与参考方向不共线，可以继续使用 referenceDirection
				referenceDirectionNew = referenceDirection;
			}

			// 创建旋转矩阵
			final xdir = velocity.clone().normalize();
			final ydir = referenceDirectionNew.clone();
			final zdir = Syntax.code('new THREE.Vector3()').crossVectors(xdir, ydir).normalize();

			final rotMat = Syntax.code('new THREE.Matrix4()');
			rotMat.set(xdir.x, ydir.x, zdir.x, 0, xdir.y, ydir.y, zdir.y, 0, xdir.z, ydir.z, zdir.z, 0, 0, 0, 0, 1);

			final euler = Syntax.code('new THREE.Euler()');
			euler.setFromRotationMatrix(rotMat);

			rotate3d.x = euler.x;
			rotate3d.y = euler.y;
			rotate3d.z = euler.z;
		}

		syncPosition();
		syncRotation();
		syncScale();

		acceleration.x = acceleration.y = acceleration.z = 0;
	}

	public function clone():IParticle {
		// 物件池取粒子
		var cloneParticle:IParticle = null;
		if (pool != null) {
			cloneParticle = pool.request();
		}

		// 沒有取到的話才創新的
		if (cloneParticle == null) {
			trace("池子裏沒有。產生新粒子");
			cloneParticle = new Particle(null, pool);
		} else {
			// 在編輯器模式下，可以隨時切換模型，所以要把池子裏粒子的mesh刪除乾净，否則會一直抓到池子裏的mesh
			ParticleSystem.getInstance().clearProxy(cloneParticle);
		}

		cloneParticle.proxy = switch (proxy) {
			case null: null;
			case _: proxy.clone();
		}

		cloneParticle.age = age;
		cloneParticle.deadAge = deadAge;
		cloneParticle.randomDeadAge = randomDeadAge;
		cloneParticle.forces = forces;
		cloneParticle.acceleration.x = acceleration.x;
		cloneParticle.acceleration.y = acceleration.y;
		cloneParticle.acceleration.z = acceleration.z;
		cloneParticle.velocity.x = velocity.x;
		cloneParticle.velocity.y = velocity.y;
		cloneParticle.velocity.z = velocity.z;
		cloneParticle.mass = mass;
		cloneParticle.rotate = (randomRotate * Math.random() - randomRotate * .5) + rotate;
		cloneParticle.rotateSpeed = rotateSpeed;
		cloneParticle.randomRotate = randomRotate;
		cloneParticle.randomPosition = randomPosition.clone();
		cloneParticle.size = (randomSize * Math.random() - randomSize * .5) + size;
		cloneParticle.randomSize = randomSize;
		cloneParticle.sizeIn = sizeIn;
		cloneParticle.sizeOut = sizeOut;
		cloneParticle.enabledRotateAlongSpeed = enabledRotateAlongSpeed;
		cloneParticle.pool = pool;

		final clonePos:Dynamic = position.clone();
		final rx = randomPosition.x * Math.random() - randomPosition.x * .5;
		final ry = randomPosition.y * Math.random() - randomPosition.y * .5;
		final rz = randomPosition.z * Math.random() - randomPosition.z * .5;
		clonePos.add(Syntax.code('new THREE.Vector3')(rx, ry, rz));
		cloneParticle.setPosition(clonePos.x, clonePos.y, clonePos.z);

		final cloneRot = rotate3d.clone();
		cloneParticle.setRotation(cloneRot.x, cloneRot.y, cloneRot.z);

		final cloneScale = scale3d.clone();
		cloneParticle.setScale(cloneScale.x, cloneScale.y, cloneScale.z);

		return cloneParticle;
	}

	public function convertToJsonObject():Dynamic {
		final obj = {
			uuid: uuid,
			name: name,
			pool: (pool != null),
			// parent: parent == null ? "" : parent.convertToJsonObject(),
			child: child == null ? "" : child.convertToJsonObject(),
			spray: spray,
			id: id,
			age: age,
			deadAge: deadAge,
			randomDeadAge: randomDeadAge,
			proxy: proxy,
			// forces: forces.map(f -> /* Convert each IForce to JSON */),
			acceleration: [acceleration.x, acceleration.y, acceleration.z],
			velocity: [velocity.x, velocity.y, velocity.z],
			mass: mass,
			rotate: rotate,
			rotateSpeed: rotateSpeed,
			randomRotate: randomRotate,
			randomPosition: [randomPosition.x, randomPosition.y, randomPosition.z],
			size: size,
			randomSize: randomSize,
			sizeIn: sizeIn,
			sizeOut: sizeOut,
			enabledRotateAlongSpeed: enabledRotateAlongSpeed,
			position: [position.x, position.y, position.z],
			rotate3d: [rotate3d.x, rotate3d.y, rotate3d.z],
			scale3d: [scale3d.x, scale3d.y, scale3d.z]
		};

		return obj;
	}
}
