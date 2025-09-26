
var vic = vic || {};
vic.shaders = vic.shaders || {};
(function () {

    const BasicShader = threejs.shaders.BasicShader;

    class RainRippleShader extends BasicShader {
        constructor() {
            super();
        }

        doWriteFragmentShader() {
            return `
                uv -= 0.5;
                uv *= 2.0;

                float distance = length(uv) * 3.14 * 3.0;
                float mask = abs(sin(distance + age * -10.));
                mask = smoothstep(.9, 1., mask);
                mask *= 1. - length(uv);

                float fadeout = 1.0 - clamp(0., 1., (age / deadAge));
                mask *= fadeout;
                mask *= 0.5;

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

    vic.shaders.RainRippleShader = RainRippleShader;
})()