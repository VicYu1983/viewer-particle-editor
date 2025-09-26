
var vic = vic || {};
vic.shaders = vic.shaders || {};
(function () {

    // const BasicShader = vic.viewer.shader.BasicShader;
    // const SpriteShader = vic.viewer.shader.SpriteShader;
    const SpriteShader = threejs.shaders.SpriteShader;

    class CloudShader extends SpriteShader {
        constructor() {
            super();
        }

        doWriteFragmentMethod(){
            // return vic.viewer.shader.method.PerlinNoise.getCode();
            return threejs.shaders.ShaderTool.getPerlinNoiseFunction();
        }

        doWriteFragmentShader() {
            return `
                vec3 xyz = vec3(uv, 0.0);
                xyz.xy *= .5;

                vec2 step = vec2(1.3, 1.7);
                float n = perlinNoise(xyz.xy, step.x, step.y, time * .4 + timeOffset);
                n = clamp(0., 1., n);

                float mask = length(uv - 0.5) * 2.;
                mask = 1.0 - clamp(0., 1., mask);
                mask *= n;

                gl_FragColor = vec4(vec3(pow(uv.y, 2.0)), pow(mask, 1.0));
            `;
        }

        doWriteFragmentUniform() {
            return new threejs.shaders.ParticleSpriteShader().doWriteFragmentUniform();
        }

        getUniforms(){
            return new threejs.shaders.ParticleSpriteShader().getUniforms();
        }
    }

    vic.shaders.CloudShader = CloudShader;
})()