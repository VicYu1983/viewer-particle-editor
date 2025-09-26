
var vic = vic || {};
vic.shaders = vic.shaders || {};
(function () {

    const BasicShader = threejs.shaders.BasicShader;

    class GlowEffectShader extends BasicShader {
        constructor() {
            super();
        }

        doWriteFragmentShader() {
            return `
                float distance = length(vUv - 0.5);
                float flipDistance = clamp(1.0 - distance, 0., 1.);
                flipDistance *= 5.0;
                flipDistance += time * 1.;
                flipDistance = mod(flipDistance, 1.0);
                float wave = clamp(1.0 - flipDistance, 0., 1.);
                float mask = smoothstep(.6,1.,(1.0 - distance));
                wave *= mask;

                vec3 c1 = vec3(1.0,0.,0.);
                vec3 c2 = vec3(0.,1.0,0.);
                vec3 c3 = mix(c1, c2, distance);

                gl_FragColor = vec4(c3, wave);
            `;
        }
    }

    vic.shaders.GlowEffectShader = GlowEffectShader;
})()