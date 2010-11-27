varying vec3 eyeVec, outNormal;
varying vec3 lightDir[gl_MaxLights];

attribute vec3 tangent;
attribute vec4 vertex;
attribute vec3 normal;

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;

void main()
{
	outNormal = normal;
	vec3 vVertex = (ModelViewMatrix * vertex).xyz;
	eyeVec = -vVertex;
	int i;

	vec3 binormal = cross( tangent, normal);

	mat3 TBN_Matrix;
	TBN_Matrix[0] =  NormalMatrix * tangent;
	TBN_Matrix[1] =  NormalMatrix * binormal;
	TBN_Matrix[2] =  NormalMatrix * normal;

	for (i = 0; i < gl_MaxLights; ++i)
	{
		lightDir[i] = gl_LightSource[i].position.xyz;
	}

	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}