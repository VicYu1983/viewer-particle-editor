package threejs.shaders;

@:expose
class SliceShader extends BasicShader {
	override function doWriteFragmentUniform():String {
		return super.doWriteFragmentUniform()
			+ '
            uniform float distance;
		';
	}

	override function doWriteFragmentShader():String {
		return '
			vec4 world_pos = world_mat * vec4(pos, 1.0);
			if(world_pos.x < distance) discard;

			float resolution = 10.0;
			float thickness = 0.95;
			float blur = 0.01;

			float grid_x = sin(world_pos.x * resolution);
			grid_x = smoothstep(thickness, thickness + blur, grid_x);
			
			float grid_y = sin(world_pos.y * resolution);
			grid_y = smoothstep(thickness, thickness + blur, grid_y);

			float grid_z = sin(world_pos.z * resolution);
			grid_z = smoothstep(thickness, thickness + blur, grid_z);

			float grid = grid_x + grid_y + grid_z;

			vec3 col = vec3(0., 0., 1.);
			col += nor * .4;
			col += vec3(grid * .3);

			float mask = world_pos.x - distance;
			mask = clamp(mask, 0., 1.);

			gl_FragColor = vec4(col, mask * 0.5);
        ';
	}
}
