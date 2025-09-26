
var vic = vic || {};
vic.shaders = vic.shaders || {};
(function () {

    // const BasicShader = vic.viewer.shader.BasicShader;
    const BasicShader = threejs.shaders.BasicShader;

    class RainShader extends BasicShader {
        constructor() {
            super();
        }

        doWriteFragmentShader() {
            return `
                // vec2 uv = vUv;
                uv -= 0.5;

                float distance = length(uv) * 2.0;
                float mask = 1.0 - distance;
                mask = clamp(mask, 0., 1.);
                mask = pow(mask, 1.0);
                mask *= .4;

                // vec3 baseColor = mix(vec3(.0, 0.5, 1.0), vec3(.7, .7, 1.0),  mask );
                // baseColor *= mask;
                // baseColor *= (sin(time + timeOffset) + 1.0) * .7;
                

                gl_FragColor = vec4(vec3(mask),mask);
            `;
        }

        doWriteFragmentUniform() {
            return new threejs.shaders.ParticleSpriteShader().doWriteFragmentUniform();
        }

        getUniforms(){
            return new threejs.shaders.ParticleSpriteShader().getUniforms();
        }
        
    }

    vic.shaders.RainShader = RainShader;
})()