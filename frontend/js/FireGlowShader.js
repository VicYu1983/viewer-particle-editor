
var vic = vic || {};
vic.shaders = vic.shaders || {};
(function () {

    const SpriteShader = threejs.shaders.SpriteShader;

    class FireGlowShader extends SpriteShader {
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
                mask = pow(mask, 2.0);

                vec3 baseColor = mix(vec3(1.0, 0.0, .0), vec3(1.0, 1.0, 1.0),  mask );
                baseColor *= mask;

                gl_FragColor = vec4(baseColor,.2);
            `;
        }

        // doWriteFragmentUniform() {
        //     return `
        //         uniform vec4 uvST;
        //     `;
        // }

        doWriteFragmentUniform() {
            return new threejs.shaders.ParticleSpriteShader().doWriteFragmentUniform();
        }

        getUniforms(){
            return new threejs.shaders.ParticleSpriteShader().getUniforms();
        }
    }

    vic.shaders.FireGlowShader = FireGlowShader;
})()