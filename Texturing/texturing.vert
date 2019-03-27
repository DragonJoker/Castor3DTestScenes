#version 140

uniform vec4 in_MatDiffuse;
uniform vec4 in_MatAmbient;
uniform float in_MatShininess;
uniform vec4 in_MatSpecular;
uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;
uniform vec4 in_LightsPosition[8];
uniform vec4 in_LightsDiffuse[8];
uniform vec4 in_LightsAmbient[8];
uniform vec4 in_LightsSpecular[8];

in vec3 tangent;
in vec4 vertex;
in vec3 normal;
in vec2 MultiTexCoord0;

out vec3 eyeNormal;
out vec3 eyeVertex;
out vec2 texCoord;

out vec3 lightDir[8];
out vec4 lightDiff[8];
out vec4 lightAmbt[8];
out vec4 lightSpec[8];

out vec4 ex_MatDiffuse;
out vec4 ex_MatAmbient;
out vec4 ex_MatSpecular;
out float ex_MatShininess;

void main()
{
	eyeNormal = NormalMatrix * normal;
	eyeVertex = (ModelViewMatrix * vertex).xyz;

	for (int i = 0 ; i < 3 ; ++i)
	{
		lightDir[i] = (ModelViewMatrix * in_LightsPosition[i]).xyz;
		lightDiff[i] = in_LightsDiffuse[i];
		lightSpec[i] = in_LightsSpecular[i];
		lightAmbt[i] = in_LightsAmbient[i];
	}

	ex_MatDiffuse = in_MatDiffuse;
	ex_MatShininess = in_MatShininess;
	ex_MatSpecular = in_MatSpecular;
	ex_MatAmbient = in_MatAmbient;

	texCoord = MultiTexCoord0;

	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}