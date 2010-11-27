attribute vec3 tangent;
attribute vec4 vertex;
attribute vec3 normal;
attribute vec2 MultiTexCoord0;

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;

varying vec2 texCoord;
varying vec3 eyeSpaceVert;
varying vec3 eyeSpaceTangent;
varying vec3 eyeSpaceBinormal;
varying vec3 eyeSpaceNormal;
varying vec3 eyeSpaceLight;

void main(void)
{ 
	vec3 binormal = cross( tangent, normal);

	eyeSpaceVert = (ModelViewMatrix * vertex).xyz;
	eyeSpaceLight = gl_LightSource[0].position.xyz;

	eyeSpaceTangent = NormalMatrix * tangent;
	eyeSpaceBinormal = NormalMatrix * binormal;
	eyeSpaceNormal = NormalMatrix * normal;

	texCoord = MultiTexCoord0;

	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}
