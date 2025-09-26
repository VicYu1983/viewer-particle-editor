package threejs.shaders;

import js.Syntax;

@:expose
class SpriteShader extends BasicShader {
	override function doWriteVertexShader():String {
		return '
                mat4 modelView = modelViewMatrix;

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

                gl_Position = projectionMatrix * modelView * vec4(position,1.0);
            ';

	}

	override function doWriteVertexUniform():String {
		return super.doWriteVertexUniform() + '
                uniform float rotate;
                uniform vec4 scale;
            ';
	}

	override function doWriteFragmentUniform():String {
		return super.doWriteFragmentUniform() + '
                uniform int usingTex;
                uniform sampler2D colorTex;
            ';
	}

	override function doWriteFragmentShader():String {
		return '
                vec4 color = baseColor;
                if(usingTex == 1){
                    color *= texture2D(colorTex, vUv);
                }
                gl_FragColor = color;
            ';
	}
}
