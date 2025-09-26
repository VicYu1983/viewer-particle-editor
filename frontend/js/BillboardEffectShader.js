
var vic = vic || {};
vic.shaders = vic.shaders || {};
(function () {

    const BasicShader = vic.viewer.shader.BasicShader;

    class BillboardEffectShader extends BasicShader {
        constructor() {
            super();
        }

        doWriteVertexShader() {
            return `
                mat4 modelView = modelViewMatrix;
                // modelView[0][0] = 1.0; 
                // modelView[0][1] = 0.0; 
                // modelView[0][2] = 0.0; 
                
                // modelView[1][0] = 0.0; 
                // modelView[1][1] = 0.0; 
                // modelView[1][2] = 1.0; 

                // modelView[2][0] = 0.0; 
                // modelView[2][1] = 1.0; 
                // modelView[2][2] = 0.0; 

                float rot = rotate;
                float sx = scale.x;
                float sy = scale.y;

                float cos_rot = cos(rot);
                float sin_rot = sin(rot);

                modelView[0][0] = cos_rot * sx; 
                modelView[0][1] = -sin_rot * sx; 
                modelView[0][2] = 0.0; 
                
                modelView[1][0] = sin_rot * sy; 
                modelView[1][1] = cos_rot * sy;
                modelView[1][2] = 0.0; 

                modelView[2][0] = 0.0; 
                modelView[2][1] = 0.0; 
                modelView[2][2] = 1.0;

                // modelView[0][0] = 1.0;
                // modelView[0][1] = 0.0;
                // modelView[0][2] = 0.0; 
                
                // modelView[1][0] = 0.0;
                // modelView[1][1] = 1.0;
                // modelView[1][2] = 0.0; 

                // modelView[2][0] = 0.0; 
                // modelView[2][1] = 0.0; 
                // modelView[2][2] = 1.0;

                gl_Position = projectionMatrix * modelView * vec4(position,1.0);
            `;
        }

        doWriteFragmentShader() {
            return `
                vec4 color = baseColor;
                if(usingTex == 1){
                    color *= texture2D(colorTex, vUv);
                }
                gl_FragColor = color;
            `;
        }

        doWriteVertexUniform() {
            return `
                uniform float rotate;
                uniform vec4 scale;
            `;
        }

        doWriteFragmentUniform() {
            return `
                uniform int usingTex;
                uniform vec4 baseColor;
                uniform sampler2D colorTex;
            `;
        }
    }

    vic.shaders.BillboardEffectShader = BillboardEffectShader;
})()