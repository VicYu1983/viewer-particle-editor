package threejs.shaders;

import js.lib.Object;
import js.Syntax;

@:expose
class BasicShader implements IShader {
	public function new() {}

	public function getVertexShader() {
		return '
        varying vec2 vUv;
        varying vec3 pos;
        varying vec3 nor;
        '
			+ doWriteVertexUniform()
			+ '
        void main() {
            vUv = uv;
            pos = position;
            nor = normal;
        '
			+ doWriteVertexShader()
			+ '
        }';
	}

	public function getFragmentShader() {
		return '
        precision mediump float;
        varying vec2 vUv;
        varying vec3 pos;
        varying vec3 nor;
        '
			+ doWriteFragmentUniform()
			+ '
        #ifdef _LMVWEBGL2_
            #if defined(MRT_NORMALS)
            layout(location = 1) out vec4 outNormal;
            #if defined(MRT_ID_BUFFER)
                layout(location = 2) out vec4 outId;
                #if defined(MODEL_COLOR)
                layout(location = 3) out vec4 outModelId;
                #endif
            #endif
            #elif defined(MRT_ID_BUFFER)
            layout(location = 1) out vec4 outId;
            #if defined(MODEL_COLOR)
                layout(location = 2) out vec4 outModelId;
            #endif
            #endif
        #else
            #define gl_FragColor gl_FragData[0]
            #if defined(MRT_NORMALS)
            #define outNormal gl_FragData[1]
            #if defined(MRT_ID_BUFFER)
                #define outId gl_FragData[2]
                #if defined(MODEL_COLOR)
                #define outModelId gl_FragData[3]
                #endif
            #endif
            #elif defined(MRT_ID_BUFFER)
            #define outId gl_FragData[1]
            #if defined(MODEL_COLOR)
                #define outModelId gl_FragData[2]
            #endif
            #endif
        #endif
        vec2 uv;'
			+ doWriteFragmentMethod()
			+ '
        void main() {
            uv = vUv * uvST.xy + uvST.zw;'
			+ doWriteFragmentShader()
			+ '
            #ifdef MRT_ID_BUFFER
            outId = vec4(0.0);
            #endif
            #ifdef MODEL_COLOR
            outModelId = vec4(0.0);
            #endif
            #ifdef MRT_NORMALS
            outNormal = vec4(0.0);
            #endif
        }';
	}

	public function doWriteVertexUniform():String {
		return '';
	}

	public function doWriteVertexShader():String {
		return '
          gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0);
        ';
	}

	public function doWriteFragmentUniform():String {
		return '
            uniform vec4 baseColor;
            uniform vec4 uvST;
            uniform float time;
        ';
	}

	public function doWriteFragmentMethod():String {
		return '';
	}

	public function doWriteFragmentShader():String {
		return 'gl_FragColor = vec4(baseColor);';
	}

	public function getUniforms():Dynamic {
		final texture = ShaderTool.getTexture(2, 2);

		final uniformString = doWriteVertexUniform() + doWriteFragmentUniform();
		final parseAry = uniformString.split(";");

		final uniforms:Dynamic = {};
		for (i in 0...parseAry.length) {
			final parse = StringTools.trim(parseAry[i]).split(" ");
			if (parse.length < 3)
				continue;
			final parseType = parse[1];
			final parseName:String = parse[2];
			final type = switch (parseType) {
				case 'float': 'f';
				case 'int': 'i';
				case 'vec2': 'v2';
				case 'vec3': 'v3';
				case 'vec4': 'v4';
				case 'sampler2D': 't';
				case _: '';
			}
			final value:Dynamic = switch (parseType) {
				case 'float', 'int': 0;
				case 'vec2': Syntax.code("new THREE.Vector2")(1, 1);
				case 'vec3': Syntax.code("new THREE.Vector3")(1, 1, 1);
				case 'vec4': Syntax.code("new THREE.Vector4")(1, 1, 1, 1);
				case 'sampler2D': texture;
				case _: 0;
			}
			Syntax.code("uniforms[{0}]={1}", parseName, {
				type: type,
				value: value
			});
		}

		uniforms.uvST.value.z = 0;
		uniforms.uvST.value.w = 0;

		return uniforms;
	}
}
