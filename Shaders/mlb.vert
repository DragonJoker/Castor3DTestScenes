varying vec3 lightVec[gl_MaxLights];
varying vec3 viewVec;
varying vec2 TexCoord;

attribute vec3 tangent;
attribute vec4 vertex;
attribute vec3 normal;
attribute vec2 MultiTexCoord0;

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;

void main( void)
{
	TexCoord = MultiTexCoord0;

	vec3 binormal = cross( tangent, normal);

	mat3 TBN_Matrix;
	TBN_Matrix[0] =  NormalMatrix * tangent;
	TBN_Matrix[1] =  NormalMatrix * binormal;
	TBN_Matrix[2] =  NormalMatrix * normal;

	vec3 vVertex = vec3( ModelViewMatrix * vertex);

	for (int i = 0 ; i < gl_MaxLights ; i++)
	{
		lightVec[i] = (ModelViewMatrix *  gl_LightSource[i].position).xyz;
		lightVec[i] = 0.02 * (lightVec[i] - vVertex);
		lightVec[i] = lightVec[i] * TBN_Matrix;
	}

	viewVec = vec3( -vVertex) * TBN_Matrix;

	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}