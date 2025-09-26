
var vic = vic || {};
vic.shaders = vic.shaders || {};
(function () {

    // const BasicShader = vic.viewer.shader.BasicShader;
    // const SpriteShader = vic.viewer.shader.SpriteShader;
    const SpriteShader = threejs.shaders.SpriteShader;

    class PerlinNoiseShader extends SpriteShader {
        constructor() {
            super();
        }

        doWriteFragmentMethod(){
            // return vic.viewer.shader.method.PerlinNoise.getCode();
            return threejs.shaders.ShaderTool.getPerlinNoiseFunction();
        }

        doWriteFragmentShader() {
            return `
                vec2 uv = vUv * uvST.xy + uvST.zw;
                vec3 xyz = vec3(uv, 0.0);

                vec2 step = vec2(1.3, 1.7);
                float n = perlinNoise(xyz.xy, step.x, step.y, time);

                gl_FragColor = vec4(0.5 + 0.5 * vec3(n,n,n),1);
            `;
        }

        doWriteFragmentUniform() {
            return `
                uniform vec4 uvST;
                uniform float time;
            `;
        }
    }

    vic.shaders.PerlinNoiseShader = PerlinNoiseShader;
})()