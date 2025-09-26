
var vic = vic || {};
vic.shaders = vic.shaders || {};
(function () {

    const SpriteShader = threejs.shaders.SpriteShader;

    class FireShader extends SpriteShader {
        constructor() {
            super();
        }

        doWriteFragmentMethod(){
            return threejs.shaders.ShaderTool.getPerlinNoiseFunction();
            // return vic.viewer.shader.method.PerlinNoise.getCode();
        }

        doWriteFragmentShader() {
            return `

                vec2 uvCenter = vUv - vec2(0.5);
                float mask = clamp(0., 1.0, length(uvCenter) * 2.0);
                float invertMask = 1.0 - mask;

                vec3 xyz = vec3(uv, 0.0);

                vec2 step = vec2(1.3, 1.7);
                float n = 0.5 + 0.5 * perlinNoise(xyz.xy, step.x, step.y, time * 16.0 + timeOffset);

                // n = pow(n, 3.0);

                vec3 outColor = vec3(n);
                outColor = outColor * invertMask;

                float baseColorMask = pow(1.0 - outColor.x, 2.0);
                vec3 baseColor = mix(vec3(1.0, 1.0, .0), vec3(1.0, 0., 0.), baseColorMask );

                // outColor = smoothstep(0.0, 1.0, outColor);
                outColor *= baseColor;

                gl_FragColor = vec4(outColor, 0.5);
                // gl_FragColor = vec4(1.0,0.,0.,1.);
            `;
        }
        
        doWriteFragmentUniform() {
            return new threejs.shaders.ParticleSpriteShader().doWriteFragmentUniform();
        }

        getUniforms(){
            return new threejs.shaders.ParticleSpriteShader().getUniforms();
        }
    }

    vic.shaders.FireShader = FireShader;
})()