package threejs.shaders;

import js.html.svg.Number;
import js.Syntax;

@:expose
class ShaderTool {
	public static function getTexture(width:Int, height:Int) {
		final texture = Syntax.code('new THREE.Texture')();
		texture.format = Syntax.code('THREE.RGBAFormat');
		texture.generateMipmaps = false;

		// 设置纹理的尺寸和数据
		texture.image = Syntax.code('new Image')();
		texture.image.width = width;
		texture.image.height = height;

		// 生成纹理的像素数据
		var data = Syntax.code('new Uint8Array')(texture.image.width * texture.image.height * 3);
		for (i in 0...data.length) {
			data[i] = Math.floor(Math.random() * 256); // 随机生成像素值
		}

		// 设置纹理的像素数据
		texture.image.data = data;

		// 更新纹理以使其生效
		texture.needsUpdate = true;

		return texture;
	}

	// public static function getParticleUniform() {
	// 	final uniform:Dynamic = getSpriteUniform();
	// 	uniform.usingNoise = {
	// 		type: 'i',
	// 		value: 0,
	// 	};

	// 	uniform.usingMask = {
	// 		type: 'i',
	// 		value: 0,
	// 	};

	// 	uniform.time = {
	// 		type: 'f',
	// 		value: 0.0
	// 	};

	// 	uniform.timeOffset = {
	// 		type: 'f',
	// 		value: 0
	// 	};

	// 	uniform.noiseStep = {
	// 		type: 'v2',
	// 		value: Syntax.code('new THREE.Vector2')(1, 1)
	// 	}

	// 	uniform.age = {
	// 		type: 'f',
	// 		value: 0
	// 	};

	// 	uniform.deadAge = {
	// 		type: 'f',
	// 		value: 0
	// 	};

	// 	return uniform;
	// }

	// public static function getSpriteUniform() {
	// 	final texture = getTexture(2, 2);
	// 	return {
	// 		rotate: {
	// 			type: 'f',
	// 			value: 0
	// 		},
	// 		scale: {
	// 			type: 'v4',
	// 			value: Syntax.code('new THREE.Vector4')(1, 1, 0, 0)
	// 		},
	// 		uvST: {
	// 			type: 'v4',
	// 			value: Syntax.code('new THREE.Vector4')(1, 1, 0, 0)
	// 		},
	// 		colorTex: {
	// 			type: 't',
	// 			value: texture,
	// 		},
	// 		baseColor: {
	// 			type: 'v4',
	// 			value: Syntax.code('new THREE.Vector4')(1, 1, 1, 1)
	// 		},
	// 		usingTex: {
	// 			type: 'i',
	// 			value: 0,
	// 		}
	// 	};
	// }

	// THREE.FrontSide = 0; THREE.BackSide = 1; THREE.DoubleSide = 2
	public static function getMaterial(uniforms:Dynamic = null, shader:IShader = null, blending:Int = 0, transparent:Bool = false, depthWrite:Bool = true,
			side:Int = 0):Dynamic {
		if (shader == null || Syntax.code("typeof shader === 'undefined'")) {
			// if (Syntax.code("typeof shader === 'undefined'")) {
			shader = new SpriteShader();
		}
		// if (Syntax.code("typeof uniforms === 'undefined'")) {
		if (uniforms == null || Syntax.code("typeof uniforms === 'undefined'")) {
			// uniforms = getSpriteUniform();
      uniforms = shader.getUniforms();
		}

		final material:Dynamic = Syntax.code('new THREE.ShaderMaterial')({
			fragmentShader: shader.getFragmentShader(),
			vertexShader: shader.getVertexShader(),
			uniforms: uniforms,
			transparent: transparent,
			blending: blending,

			// 用threejs的mesh的話，要關閉depthWrite，否則渲染不出透明度
			depthWrite: depthWrite,
			side: side
		});

		material.supportsMrtNormals = true;
    material.needUpdate = true;

		// Syntax.code('viewer.impl.matman().addMaterial')("test", material, true);

		return material;
	}

	public static function getSpriteMesh(uniforms:Dynamic = null, shader:IShader = null, width:Float = 1.0, height:Float = 1.0, blending:Int = 0,
			transparent:Bool = false, side:Int = 0) {
		final spriteShaderMaterial:Dynamic = getMaterial(uniforms, shader, blending, transparent, !transparent, side);
		return Syntax.code('new THREE.Mesh')(Syntax.code('new THREE.PlaneBufferGeometry')(width, height), spriteShaderMaterial);
	}

	public static function getPerlinNoiseFunction() {
		return '
            
            vec3 mod289(vec3 x)
            {
                return x - floor(x * (1.0 / 289.0)) * 289.0;
            }
            
            vec4 mod289(vec4 x)
            {
              return x - floor(x * (1.0 / 289.0)) * 289.0;
            }
            
            vec4 permute(vec4 x)
            {
              return mod289(((x*34.0)+10.0)*x);
            }
            
            vec4 taylorInvSqrt(vec4 r)
            {
              return 1.79284291400159 - 0.85373472095314 * r;
            }
            
            vec3 fade(vec3 t) {
              return t*t*t*(t*(t*6.0-15.0)+10.0);
            }
            
            // Classic Perlin noise
            float cnoise(vec3 P)
            {
              vec3 Pi0 = floor(P); // Integer part for indexing
              vec3 Pi1 = Pi0 + vec3(1.0); // Integer part + 1
              Pi0 = mod289(Pi0);
              Pi1 = mod289(Pi1);
              vec3 Pf0 = fract(P); // Fractional part for interpolation
              vec3 Pf1 = Pf0 - vec3(1.0); // Fractional part - 1.0
              vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
              vec4 iy = vec4(Pi0.yy, Pi1.yy);
              vec4 iz0 = Pi0.zzzz;
              vec4 iz1 = Pi1.zzzz;
            
              vec4 ixy = permute(permute(ix) + iy);
              vec4 ixy0 = permute(ixy + iz0);
              vec4 ixy1 = permute(ixy + iz1);
            
              vec4 gx0 = ixy0 * (1.0 / 7.0);
              vec4 gy0 = fract(floor(gx0) * (1.0 / 7.0)) - 0.5;
              gx0 = fract(gx0);
              vec4 gz0 = vec4(0.5) - abs(gx0) - abs(gy0);
              vec4 sz0 = step(gz0, vec4(0.0));
              gx0 -= sz0 * (step(0.0, gx0) - 0.5);
              gy0 -= sz0 * (step(0.0, gy0) - 0.5);
            
              vec4 gx1 = ixy1 * (1.0 / 7.0);
              vec4 gy1 = fract(floor(gx1) * (1.0 / 7.0)) - 0.5;
              gx1 = fract(gx1);
              vec4 gz1 = vec4(0.5) - abs(gx1) - abs(gy1);
              vec4 sz1 = step(gz1, vec4(0.0));
              gx1 -= sz1 * (step(0.0, gx1) - 0.5);
              gy1 -= sz1 * (step(0.0, gy1) - 0.5);
            
              vec3 g000 = vec3(gx0.x,gy0.x,gz0.x);
              vec3 g100 = vec3(gx0.y,gy0.y,gz0.y);
              vec3 g010 = vec3(gx0.z,gy0.z,gz0.z);
              vec3 g110 = vec3(gx0.w,gy0.w,gz0.w);
              vec3 g001 = vec3(gx1.x,gy1.x,gz1.x);
              vec3 g101 = vec3(gx1.y,gy1.y,gz1.y);
              vec3 g011 = vec3(gx1.z,gy1.z,gz1.z);
              vec3 g111 = vec3(gx1.w,gy1.w,gz1.w);
            
              vec4 norm0 = taylorInvSqrt(vec4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
              g000 *= norm0.x;
              g010 *= norm0.y;
              g100 *= norm0.z;
              g110 *= norm0.w;
              vec4 norm1 = taylorInvSqrt(vec4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
              g001 *= norm1.x;
              g011 *= norm1.y;
              g101 *= norm1.z;
              g111 *= norm1.w;
            
              float n000 = dot(g000, Pf0);
              float n100 = dot(g100, vec3(Pf1.x, Pf0.yz));
              float n010 = dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z));
              float n110 = dot(g110, vec3(Pf1.xy, Pf0.z));
              float n001 = dot(g001, vec3(Pf0.xy, Pf1.z));
              float n101 = dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z));
              float n011 = dot(g011, vec3(Pf0.x, Pf1.yz));
              float n111 = dot(g111, Pf1);
            
              vec3 fade_xyz = fade(Pf0);
              vec4 n_z = mix(vec4(n000, n100, n010, n110), vec4(n001, n101, n011, n111), fade_xyz.z);
              vec2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
              float n_xyz = mix(n_yz.x, n_yz.y, fade_xyz.x); 
              return 2.2 * n_xyz;
            }
            
            // Classic Perlin noise, periodic variant
            float pnoise(vec3 P, vec3 rep)
            {
              vec3 Pi0 = mod(floor(P), rep); // Integer part, modulo period
              vec3 Pi1 = mod(Pi0 + vec3(1.0), rep); // Integer part + 1, mod period
              Pi0 = mod289(Pi0);
              Pi1 = mod289(Pi1);
              vec3 Pf0 = fract(P); // Fractional part for interpolation
              vec3 Pf1 = Pf0 - vec3(1.0); // Fractional part - 1.0
              vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
              vec4 iy = vec4(Pi0.yy, Pi1.yy);
              vec4 iz0 = Pi0.zzzz;
              vec4 iz1 = Pi1.zzzz;
            
              vec4 ixy = permute(permute(ix) + iy);
              vec4 ixy0 = permute(ixy + iz0);
              vec4 ixy1 = permute(ixy + iz1);
            
              vec4 gx0 = ixy0 * (1.0 / 7.0);
              vec4 gy0 = fract(floor(gx0) * (1.0 / 7.0)) - 0.5;
              gx0 = fract(gx0);
              vec4 gz0 = vec4(0.5) - abs(gx0) - abs(gy0);
              vec4 sz0 = step(gz0, vec4(0.0));
              gx0 -= sz0 * (step(0.0, gx0) - 0.5);
              gy0 -= sz0 * (step(0.0, gy0) - 0.5);
            
              vec4 gx1 = ixy1 * (1.0 / 7.0);
              vec4 gy1 = fract(floor(gx1) * (1.0 / 7.0)) - 0.5;
              gx1 = fract(gx1);
              vec4 gz1 = vec4(0.5) - abs(gx1) - abs(gy1);
              vec4 sz1 = step(gz1, vec4(0.0));
              gx1 -= sz1 * (step(0.0, gx1) - 0.5);
              gy1 -= sz1 * (step(0.0, gy1) - 0.5);
            
              vec3 g000 = vec3(gx0.x,gy0.x,gz0.x);
              vec3 g100 = vec3(gx0.y,gy0.y,gz0.y);
              vec3 g010 = vec3(gx0.z,gy0.z,gz0.z);
              vec3 g110 = vec3(gx0.w,gy0.w,gz0.w);
              vec3 g001 = vec3(gx1.x,gy1.x,gz1.x);
              vec3 g101 = vec3(gx1.y,gy1.y,gz1.y);
              vec3 g011 = vec3(gx1.z,gy1.z,gz1.z);
              vec3 g111 = vec3(gx1.w,gy1.w,gz1.w);
            
              vec4 norm0 = taylorInvSqrt(vec4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
              g000 *= norm0.x;
              g010 *= norm0.y;
              g100 *= norm0.z;
              g110 *= norm0.w;
              vec4 norm1 = taylorInvSqrt(vec4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
              g001 *= norm1.x;
              g011 *= norm1.y;
              g101 *= norm1.z;
              g111 *= norm1.w;
            
              float n000 = dot(g000, Pf0);
              float n100 = dot(g100, vec3(Pf1.x, Pf0.yz));
              float n010 = dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z));
              float n110 = dot(g110, vec3(Pf1.xy, Pf0.z));
              float n001 = dot(g001, vec3(Pf0.xy, Pf1.z));
              float n101 = dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z));
              float n011 = dot(g011, vec3(Pf0.x, Pf1.yz));
              float n111 = dot(g111, Pf1);
            
              vec3 fade_xyz = fade(Pf0);
              vec4 n_z = mix(vec4(n000, n100, n010, n110), vec4(n001, n101, n011, n111), fade_xyz.z);
              vec2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
              float n_xyz = mix(n_yz.x, n_yz.y, fade_xyz.x); 
              return 2.2 * n_xyz;
            }
            
            // demo code:
            float _color(vec2 xy, float _time) { return cnoise(vec3(1.5*xy, 0.3 * _time)); }

            float perlinNoise(vec2 uv, float stepX, float stepY, float _time){
                vec3 xyz = vec3(uv, 0.0);
                vec2 step = vec2(stepX, stepY);
                float n = _color(xyz.xy, _time);
                n += 0.5 * _color(xyz.xy * 2.0 - step, _time);
                n += 0.25 * _color(xyz.xy * 4.0 - 2.0 * step, _time);
                n += 0.125 * _color(xyz.xy * 8.0 - 3.0 * step, _time);
                n += 0.0625 * _color(xyz.xy * 16.0 - 4.0 * step, _time);
                n += 0.03125 * _color(xyz.xy * 32.0 - 5.0 * step, _time);
                return n;
            }
            ';

	}
}
