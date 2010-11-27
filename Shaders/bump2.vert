varying vec3 lightVec; 
varying vec3 eyeVec;
varying vec2 texCoord;

attribute vec3 tangent;
attribute vec4 vertex;
attribute vec3 normal;
attribute vec2 MultiTexCoord0;

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;

void main(void)
{
	texCoord = MultiTexCoord0;

	vec3 binormal = cross( tangent, normal);

	mat3 TBN_Matrix;
	TBN_Matrix[0] =  NormalMatrix * tangent;
	TBN_Matrix[1] =  NormalMatrix * binormal;
	TBN_Matrix[2] =  NormalMatrix * normal;

	vec3 vVertex = vec3( ModelViewMatrix * vertex);
	vec4 lightEye = ModelViewMatrix *  gl_LightSource[0].position;
	lightVec = 0.02* (lightEye.xyz - vVertex);
	lightVec = lightVec * TBN_Matrix;

	eyeVec = -vVertex * TBN_Matrix;

	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}