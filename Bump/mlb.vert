varying vec3 lightVec[3];
varying vec4 lightSpec[3];
varying vec4 lightDiff[3];
varying vec3 viewVec;
varying vec2 TexCoord;

attribute vec3 tangent;
attribute vec4 vertex;
attribute vec3 normal;
attribute vec2 MultiTexCoord0;

uniform vec4 in_LightsPosition[8];
uniform vec4 in_LightsDiffuse[8];
uniform vec4 in_LightsSpecular[8];
uniform float in_MatShininess;
uniform vec4 in_MatDiffuse;

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;

varying float ex_MatShininess;
varying vec4 ex_MatDiffuse;

void main( void)
{
	TexCoord = MultiTexCoord0;

	vec3 binormal = cross( tangent, normal);

	mat3 TBN_Matrix;
	TBN_Matrix[0] =  NormalMatrix * tangent;
	TBN_Matrix[1] =  NormalMatrix * binormal;
	TBN_Matrix[2] =  NormalMatrix * normal;

	vec3 vVertex = vec3( ModelViewMatrix * vertex);

	for (int i = 0 ; i < 3 ; i++)
	{
		lightVec[i] = (ModelViewMatrix *  in_LightsPosition[i]).xyz;
		lightVec[i] = 0.02 * (lightVec[i] - vVertex);
		lightVec[i] = lightVec[i] * TBN_Matrix;
		lightSpec[i] = in_LightsSpecular[i];
		lightDiff[i] = in_LightsDiffuse[i];
	}

	ex_MatShininess = in_MatShininess;
	ex_MatDiffuse = in_MatDiffuse;

	viewVec = vec3( -vVertex) * TBN_Matrix;

	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}