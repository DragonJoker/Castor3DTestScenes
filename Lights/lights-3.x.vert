#version 140

in vec3 tangent;
in vec4 vertex;
in vec3 normal;

uniform vec4 in_MatDiffuse;
uniform vec4 in_MatAmbient;
uniform vec4 in_MatEmissive;
uniform float in_MatShininess;
uniform vec4 in_MatSpecular;
uniform mat4 ProjectionModelViewMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;
uniform vec4 in_LightsPosition[8];
uniform vec4 in_LightsDiffuse[8];
uniform vec4 in_LightsAmbient[8];
uniform vec4 in_LightsSpecular[8];

out vec3 eyeNormal;
out vec3 eyeVertex;

out vec3 ex_LightsPosition[8];
out vec4 ex_LightsDiffuse[8];
out vec4 ex_LightsAmbient[8];
out vec4 ex_LightsSpecular[8];

out vec4 ex_MatDiffuse;
out vec4 ex_MatAmbient;
out vec4 ex_MatSpecular;
out float ex_MatShininess;
out vec4 ex_MatEmissive;

void main()
{
	eyeNormal = normalize( NormalMatrix * normal);
	eyeVertex = normalize( (ModelViewMatrix * vertex).xyz);
	int i;

	for (i = 0 ; i < 3 ; ++i)
	{
		ex_LightsPosition[i] = normalize( (ModelViewMatrix * in_LightsPosition[i]).xyz);
		ex_LightsDiffuse[i] = in_LightsDiffuse[i];
		ex_LightsSpecular[i] = in_LightsSpecular[i];
		ex_LightsAmbient[i] = in_LightsAmbient[i];
	}

	ex_MatDiffuse = in_MatDiffuse;
	ex_MatAmbient = in_MatAmbient;
	ex_MatEmissive = in_MatEmissive;
	ex_MatSpecular = in_MatSpecular;
	ex_MatShininess = in_MatShininess;

	gl_Position = ProjectionModelViewMatrix * vertex;
}