package threejs.shaders;

interface IShader {
	function getVertexShader():String;
	function doWriteVertexUniform():String;
	function doWriteVertexShader():String;
	function getFragmentShader():String;
	function doWriteFragmentUniform():String;
	function doWriteFragmentMethod():String;
	function doWriteFragmentShader():String;
	function getUniforms():Dynamic;
}
