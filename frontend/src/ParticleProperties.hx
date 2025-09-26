import component.CustomView;
import threejs.particle.system.IParticle;

enum Name {
	DEAD;
	DEAD_RANDOM;
	ACCELERATION_X;
	ACCELERATION_Y;
	ACCELERATION_Z;
	VELOCITY_X;
	VELOCITY_Y;
	VELOCITY_Z;
	MASS;
	ANGLE;
	ANGLE_RANDOM;
	ROTATION_SPEED;
	POSITION_X;
	POSITION_Y;
	POSITION_Z;
	POSITION_RANDOM_X;
	POSITION_RANDOM_Y;
	POSITION_RANDOM_Z;
	SCALE;
	SCALE_RANDOM;
	GROWTH_TIME;
	SHRINK_TIME;

	HORIZON_ANGLE;
	HORIZON_RANDOM;
	VERTICAL_ANGLE;
	VERTICAL_RANDOM;
	FORCE;
	RATE;
}

class ParticleProperties {
	public static final instances:Map<IParticle, Array<Array<Float>>> = new Map();

	public static function convertToJsonObject(facade:MainView) {
		final obj = [];
		final particles = instances.keys();
		while (particles.hasNext()) {
			final particle = particles.next();
			final minMax = instances.get(particle);
			obj.push({
				uuid: particle.uuid,
				minMax: minMax
			});
		}
		return obj;
	}

	public static function getInstance(particle:IParticle, prosList:Map<ParticleProperties.Name, CustomView>):Array<Array<Float>> {
		if (instances.exists(particle)) {
			return instances.get(particle);
		}
		final keys = prosList.keys();
		final arys:Array<Array<Float>> = [];
		while (keys.hasNext()) {
			final key = keys.next();
			final view = prosList.get(key);
			final ary = [view.minPos, view.maxPos];
			arys.push(ary);
		}
		instances.set(particle, arys);
		return arys;
	}

	public static function setInstance(particle:IParticle, prosList:Map<ParticleProperties.Name, CustomView>) {
		if (!instances.exists(particle)) {
			return;
		}
		final minMaxs:Array<Array<Float>> = ParticleProperties.getInstance(particle, prosList);
		final keys = prosList.keys();
		var id = 0;
		while (keys.hasNext()) {
			final key = keys.next();
			final view = prosList.get(key);
			final minMax = minMaxs[id++];
			minMax[0] = view.minPos;
			minMax[1] = view.maxPos;
		}
	}

	public static function removeInstance(particle:IParticle) {
		instances.remove(particle);
	}

	public static var translations:Map<Name, String> = [
		Name.DEAD => "生命長度",
		Name.DEAD_RANDOM => "生命隨機",
		Name.ACCELERATION_X => "加速度x",
		Name.ACCELERATION_Y => "加速度y",
		Name.ACCELERATION_Z => "加速度z",
		Name.VELOCITY_X => "速度x",
		Name.VELOCITY_Y => "速度y",
		Name.VELOCITY_Z => "速度z",
		Name.POSITION_X => "位置x",
		Name.POSITION_Y => "位置y",
		Name.POSITION_Z => "位置z",
		Name.MASS => "質量",
		Name.ANGLE => "角度",
		Name.ANGLE_RANDOM => "角度隨機",
		Name.ROTATION_SPEED => "旋轉速度",
		Name.POSITION_RANDOM_X => "位置隨機x",
		Name.POSITION_RANDOM_Y => "位置隨機y",
		Name.POSITION_RANDOM_Z => "位置隨機z",
		Name.SCALE => "縮放",
		Name.SCALE_RANDOM => "縮放隨機",
		Name.GROWTH_TIME => "放大時間",
		Name.SHRINK_TIME => "縮小時間",
		Name.HORIZON_ANGLE => "水平角度",
		Name.HORIZON_RANDOM => "水平隨機",
		Name.VERTICAL_ANGLE => "垂直角度",
		Name.VERTICAL_RANDOM => "垂直隨機",
		Name.FORCE => "力道",
		Name.RATE => "頻率"
	];

	// 获取中文字符串表示的颜色
	public static function translate(name:Name):String {
		return translations.get(name);
	}
}
