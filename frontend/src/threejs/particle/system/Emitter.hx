package threejs.particle.system;

import js.Syntax;

@:expose
class Emitter extends Particle {
	private var spawnLeftTime:Float = 0;

	public function new(proxy:Dynamic = null, pool:ParticlePool = null) {
		super(proxy, pool);
	}

	override function setParticle(particle:IParticle) {
		child = particle;
		particle.parent = this;
	}

	override function update(delta:Float) {
		super.update(delta);

		if (child != null) {
			spawnLeftTime += delta;

			final spawnGap = 1 / spray.rate;
			final spawnCount = Math.floor(spawnLeftTime / spawnGap);

			for (i in 0...spawnCount) {
				final clone = child.clone();
				clone.deadAge = clone.deadAge + (Math.random() - 0.5) * clone.randomDeadAge;

				final clonePos = position.clone();
				final rx = clone.randomPosition.x * (Math.random() - 0.5);
				final ry = clone.randomPosition.y * (Math.random() - 0.5);
				final rz = clone.randomPosition.z * (Math.random() - 0.5);
				clonePos.add(Syntax.code('new THREE.Vector3')(rx, ry, rz));
				clone.setPosition(clonePos.x, clonePos.y, clonePos.z);

				// 先決定主要的方向
				var hx = Math.cos(spray.horizonAngle);
				var hy = Math.sin(spray.horizonAngle);
				var vx = Math.cos(spray.verticalAngle);
				var vy = Math.sin(spray.verticalAngle);
				var xdir = Syntax.code('new THREE.Vector3')(hx, hy, 0);
				xdir = xdir.multiplyScalar(vx).add(Syntax.code('new THREE.Vector3')(0, 0, vy));
				xdir.normalize();

				// 用cross找出主要方向的橫向方向
				final ydir = Syntax.code('new THREE.Vector3')(0, 0, 1).cross(xdir);
				ydir.normalize();

				// 用cross找出主要方向的縱向方向
				final zdir = ydir.clone();
				zdir.cross(xdir);
				zdir.normalize();

				// 找出橫向坐標
				var rh = (Math.random() * spray.horizonRandom) - (spray.horizonRandom * .5);
				hx = Math.cos(rh);
				hy = Math.sin(rh);
				var dir = xdir.clone();
				dir.multiplyScalar(hx).add(ydir.clone().multiplyScalar(hy));

				// 利用橫向坐標找出縱向坐標
				rh = (Math.random() * spray.verticalRandom) - (spray.verticalRandom * .5);
				hx = Math.cos(rh);
				hy = Math.sin(rh);
				dir.multiplyScalar(hx).add(zdir.clone().multiplyScalar(hy));

				dir.normalize().multiplyScalar(spray.force);

				clone.applyForce(dir);

				dispatchEvent(new EventWithParams('onParticleSpawn', {particle: clone}));
			}

			spawnLeftTime = spawnLeftTime % spawnGap;
		}
	}

	override function clone():IParticle {
		var clone = null;
		if (proxy)
			clone = proxy.clone();

		// 物件池取粒子
		var cloneParticle:IParticle = null;
		if (pool != null) {
			cloneParticle = pool.request();
		}

		// 沒有取到的話才創新的
		if (cloneParticle == null) {
			trace("池子裏沒有。產生新粒子");
			cloneParticle = new Emitter(null, pool);
		} else {
			// 在編輯器模式下，可以隨時切換模型，所以要把池子裏粒子的mesh刪除乾净，否則會一直抓到池子裏的mesh
			ParticleSystem.getInstance().clearProxy(cloneParticle);
		}

		cloneParticle.proxy = switch (proxy) {
			case null: null;
			case _: proxy.clone();
		}

		// 把scale調回來
		if (cloneParticle.proxy != null) {
			cloneParticle.proxy.scale.x = cloneParticle.proxy.scale.y = cloneParticle.proxy.scale.z = 1.0;
		}

		if (child != null)
			cloneParticle.setParticle(child);

		cloneParticle.spray.horizonAngle = spray.horizonAngle;
		cloneParticle.spray.horizonRandom = spray.horizonRandom;
		cloneParticle.spray.verticalAngle = spray.verticalAngle;
		cloneParticle.spray.verticalRandom = spray.verticalRandom;
		cloneParticle.spray.force = spray.force;
		cloneParticle.spray.rate = spray.rate;
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
		final rx = randomPosition.x * (Math.random() - 0.5);
		final ry = randomPosition.y * (Math.random() - 0.5);
		final rz = randomPosition.z * (Math.random() - 0.5);
		clonePos.add(Syntax.code('new THREE.Vector3')(rx, ry, rz));
		cloneParticle.setPosition(clonePos.x, clonePos.y, clonePos.z);

		final cloneRot = rotate3d.clone();
		cloneParticle.setRotation(cloneRot.x, cloneRot.y, cloneRot.z);

		final cloneScale = scale3d.clone();
		cloneParticle.setScale(cloneScale.x, cloneScale.y, cloneScale.z);

		return cloneParticle;
	}

	override function convertToJsonObject():Dynamic {
		return super.convertToJsonObject();
	}
}
