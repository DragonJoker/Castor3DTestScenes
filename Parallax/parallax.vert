attribute vec3 tangent;
attribute vec4 vertex;
attribute vec3 normal;
attribute vec2 MultiTexCoord0;

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;

varying vec3 eyeVec;
varying vec2 TexCoord;
varying vec3 eyeSpaceLight;

void main() 
{
	TexCoord = MultiTexCoord0;

	vec3 binormal = cross( tangent, normal);
	
	eyeSpaceLight = (ModelViewMatrix * in_Lights0Position).xyz;

	mat3 TBN_Matrix;
	TBN_Matrix[0] =  NormalMatrix * tangent;
	TBN_Matrix[1] =  NormalMatrix * binormal;
	TBN_Matrix[2] =  NormalMatrix * normal;

	vec4 VertexModelView = ModelViewMatrix * vertex;
	eyeVec = vec3( -VertexModelView) * TBN_Matrix;

	// Vertex transformation
	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}
