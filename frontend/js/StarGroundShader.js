
var vic = vic || {};
vic.shaders = vic.shaders || {};
(function () {

    const BasicShader = threejs.shaders.BasicShader;

    class StarGroundShader extends BasicShader {
        constructor() {
            super();
        }

        doWriteFragmentShader() {
            return `

                vec2 uv = vUv * 40.0;
                uv = fract(uv);
                uv -= 0.5;

                float distance = clamp(0., 1.0, length(uv) * 2.0);
                distance = 1.0 - distance;
                distance = pow(distance, 50.0);

                vec3 col = vec3(0., .5, 1.0);
                col *= distance;

                gl_FragColor = vec4(col,1.0);
            `;
        }

        // doWriteFragmentUniform() {
        //     return `
        //         uniform vec4 uvST;
        //         uniform float timeOffset;
        //         uniform float time;
        //     `;
        // }
    }

    vic.shaders.StarGroundShader = StarGroundShader;
})()