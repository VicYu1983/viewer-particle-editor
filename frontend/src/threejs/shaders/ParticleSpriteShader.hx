package threejs.shaders;

import js.Syntax;

@:expose
class ParticleSpriteShader extends SpriteShader {
	public function new() {
		super();
	}

	override function doWriteFragmentMethod():String {
		return ShaderTool.getPerlinNoiseFunction();
	}

	override function doWriteFragmentShader():String {
		return '
			vec4 color = baseColor;
			if(usingTex == 1){
				color *= texture2D(colorTex, vUv);
			}
			if(usingNoise == 1){
				color *= perlinNoise(vUv, noiseStep.x, noiseStep.y, age);
			}
			if(usingMask == 1){
				float mask = 1.0 - clamp(0., 1., (length(vUv - 0.5) * 2.0));
				color *= mask;
			}
			gl_FragColor = color;
		';
	}

	override function doWriteFragmentUniform():String {
		return super.doWriteFragmentUniform() + '
            uniform int usingNoise;
			uniform int usingMask;
			uniform vec2 noiseStep;
			uniform float timeOffset;
			uniform float age;
			uniform float deadAge;
        ';
	}
}
