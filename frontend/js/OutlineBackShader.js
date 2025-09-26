
var vic = vic || {};
vic.shaders = vic.shaders || {};
(function () {

    const BasicShader = threejs.shaders.BasicShader;

    class OutlineBackShader extends BasicShader {
        constructor() {
            super();
        }

        doWriteFragmentShader() {
            return `
                vec2 uv = vUv * 3.1415926;
                uv = 1.0 - sin(uv);

                float gray = dot(vec3(uv, 1.), vec3(0.2126, 0.7152, 0.0722));
                vec3 col = vec3(uv.x + uv.y);

                col = vec3(pow(mix(uv.y, 1., uv.x), 10.0)) ;
                col += pow(clamp(0., 1., pos.y * .05), 2.0);

                col += abs(sin(pos.y * 5.0)) * sin(pos.y * .3 + time * 1.0);

                gl_FragColor = vec4(.0, 0.5, 1.0, col * .5);
            `;
        }

        doWriteFragmentUniform() {
            return `
                uniform vec4 uvST;
                uniform float time;
                uniform float timeOffset;
            `;
        }
    }

    vic.shaders.OutlineBackShader = OutlineBackShader;
})()